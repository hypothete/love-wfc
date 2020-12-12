-- core algorithm
-- follows the tutorial https://www.gridbugs.org/wave-function-collapse

Core = Object:extend()
Cell = Object:extend()
EntropyCoord = Object:extend()
RemovalUpdate = Object:extend()
TileEnablerCount = Object:extend()

DIRECTIONS = { 'n', 's', 'e', 'w' }

function TileEnablerCount:new(tileIndex)
  local weight = self.weights.getWeight(tileIndex)
  self.n = #weight.n
  self.s = #weight.s
  self.e = #weight.e
  self.w = #weight.w
end

function TileEnablerCount:containsAnyZeroCount()
  return self.n == 0 or self.s == 0 or self.e == 0 or self.w == 0
end

function Cell:new(weights)
  self.weights = weights
  self.possible = {}
  self.sumOfPossibleWeights = 0
  self.sumOfPossibleWeightsLogWeights = 0
  self.tileEnablerCounts = {}
  for i = 1, self.weights.numTiles do
    -- set all options to true
    table.insert(self.possible, true)
    -- build the tileEnablerCount table
    local tec = TileEnablerCount(i - 1)
    table.insert(self.tileEnablerCounts, tec)
    -- set all weights to max
    local rf, rl = self.weights.getFrequency(i - 1)
    self.sumOfPossibleWeights = self.sumOfPossibleWeights + rf
    self.sumOfPossibleWeightsLogWeights = self.sumOfPossibleWeightsLogWeights + rl
  end
  -- precomputed entropy
  self.noise = love.math.random() / 10000
  -- can be modified
  self.collapsed = false
end

function Cell:removeTile(tileIndex)
  self.possible[tileIndex + 1] = false
  local rf, rl = self.weights.getFrequency(tileIndex)
  self.sumOfPossibleWeights = self.sumOfPossibleWeights - rf
  self.sumOfPossibleWeightsLogWeights = self.sumOfPossibleWeightsLogWeights - rl
end

function Cell:hasNoPossibleTiles()
  local res = false
  for i=1, self.weights.numTiles do
    res = res or self.possible[i]
  end
  return not res
end

function Cell:getEntropy()
  return math.log(self.sumOfPossibleWeights, 2) -
    (self.sumOfPossibleWeightsLogWeights / self.sumOfPossibleWeights)
end

function Cell:chooseTileIndex()
  local remaining = love.math.random() * self.sumOfPossibleWeights
  for i = 1, self.weights.numTiles do
    if self.possible[i] then
      local rf = self.weights.getFrequency(i - 1)
      if remaining >= rf then
        remaining = remaining - rf
      else
        return i
      end
    end
  end
end

function Cell:getOnlyPossible()
  for i=1, self.weights.numTiles do
    if self.possible[i] then
      return i - 1
    end
  end
end

function EntropyCoord:new(x, y, e)
  self.x = x
  self.y = y
  self.e = e
end

function RemovalUpdate:new(core, x,y,tile)
  self.core = core
  self.x = x
  self.y = y
  self.tile = tile
end

function RemovalUpdate:getNeighbor(dir)
  -- origin 1,1 for table lookup
  -- loops around xy
  local dx = self.x
  local dy = self.y
  if dir == 'n' then
    dy = self.y - 1
    if dy < 1 then dy = dy + self.core.map.height end
  elseif dir == 's' then
    dy = self.y + 1
    if dy > self.core.map.height then dy = dy - self.core.map.height end
  elseif dir == 'e' then
    dx = self.x + 1
    if dx > self.core.map.width then dx = dx - self.core.map.width end
  elseif dir == 'w' then
    dx = self.x - 1
    if dx < 1 then dx = dx + self.core.map.width end
  end
  return dx, dy
end

function Core:new(map, weights)
  self.map = map
  self.weights = weights
  self.remaining = self.map.width * self.map.height
  self.grid = {}
  self.final = {}

  -- working table for uncollapsed cells
  self.entropyHeap = {}

  -- working table for propagation
  self.tileRemovals = {}
  
  -- build the cell grid
  for i = 1, self.map.width do
    table.insert(self.grid, {})
    for j = 1, self.map.height do
      local cell = Cell(self.weights)
      table.insert(self.grid[i], cell)
      local coord = EntropyCoord(i, j, cell:getEntropy())
      table.insert(self.entropyHeap, coord)
    end
  end

  -- run!
  self:run()
  
  -- final is the generated output
  for i = 1, self.map.width do
    table.insert(self.final, {})
    for j = 1, self.map.height do
      local cell = self.grid[i][j]
      table.insert(self.final, cell:getOnlyPossible())
    end
  end
end

function Core:chooseNextCell()
  table.sort(self.entropyHeap, function(a, b)
    return a.e > b.e
  end)
  local coord = table.remove(self.entropyHeap)
  while coord do
    local cell = self.grid[coord.x][coord.y]
    if not cell.collapsed then
      return coord.x, coord.y
    end
    coord = table.remove(self.entropyHeap)
  end
end

function Core:collapseCellAt(x, y)
  local cell = self.grid[x][y]
  local tileIndexToCollapse = cell:chooseTileIndex()
  cell.collapsed = true
  for i = 1, self.weights.numTiles do
    if tileIndexToCollapse ~= (i - 1) then
      cell.possible[i] = false
      local removal = RemovalUpdate(self, x, y, i - 1)
      table.insert(self.tileRemovals, removal)
    end
  end
end

function Core:propagate()
  local removalUpdate = table.remove(self.tileRemovals)
  while removalUpdate do
    for i = 1, #DIRECTIONS do
      local dir = DIRECTIONS[i]
      local neighborX, neighborY = removalUpdate:getNeighbor(dir)
      local neighborCell = self.grid[neighborX][neighborY]
      local currentTile = self.weights.getWeight(removalUpdate.tileIndex)
      for j = 1, #currentTile[dir] do
        local compatTileId = currentTile[i]
        local enabler = neighborCell.tileEnablerCounts[compatTileId+1]
        if enabler[dir] == 1 then
          if not enabler:containsAnyZeroCount() then
            neighborCell:removeTile(
              compatTileId
            )
            if neighborCell:hasNoPossibleTiles() then
              print('ERROR no options at '..neighborX..' '..neighborY)
              return
            end
            local eCoord = EntropyCoord(neighborX, neighborY, neighborCell:getEntropy())
            table.insert(self.entropyHeap, eCoord)
            local nRemUpdate = RemovalUpdate(self, neighborX, neighborY, compatTileId)
            table.insert(self.tileRemovals, nRemUpdate)
          end
        end
        enabler[dir] = enabler[dir] - 1
      end
    end
    removalUpdate = table.remove(self.tileRemovals)
  end
end

function Core:run()
  while self.remaining > 0 do
    local x, y = self:chooseNextCell()
    self:collapseCellAt(x, y)
    self:propagate()
    self.remaining = self.remaining - 1
  end
end