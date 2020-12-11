-- core algorithm
-- follows the tutroial https://www.gridbugs.org/wave-function-collapse

Core = Object:extend()
Cell = Object:extend()
EntropyCoord = Object:extend()
RemovalUpdate = Object:extend()
TileEnablerCount = Object:extend()

function TileEnablerCount:new(tileIndex)
  local weight = getWeight(tileIndex)
  self.n = #weight.n
  self.s = #weight.s
  self.e = #weight.e
  self.w = #weight.w
end

function Cell:new()
  self.possible = {}
  self.sumOfPossibleWeights = 0
  self.sumOfPossibleWeightsLogWeights = 0
  self.tileEnablerCounts = {}
  for i=1, numTiles do
    -- set all options to true
    table.insert(self.possible, true)
    -- build the tileEnablerCount table
    local tec = TileEnablerCount(i - 1)
    table.insert(self.tileEnablerCounts, tec)
    -- set all weights to max
    local rf, rl = getFrequency(i - 1)
    self.sumOfPossibleWeights = self.sumOfPossibleWeights + rf
    self.sumOfPossibleWeightsLogWeights = self.sumOfPossibleWeightsLogWeights + rl
  end
  -- precomputed entropy
  self.noise = love.math.random() / 100
  -- can be modified
  self.collapsed = false
end

function Cell:removeTile(tileIndex)
  self.possible[tileIndex + 1] = false
  local rf, rl = getFrequency(tileIndex)
  self.sumOfPossibleWeights = self.sumOfPossibleWeights - rf
  self.sumOfPossibleWeightsLogWeights = self.sumOfPossibleWeightsLogWeights - rl
end

function Cell:getEntropy()
  return math.log(self.sumOfPossibleWeights, 2) -
    (self.sumOfPossibleWeightsLogWeights / self.sumOfPossibleWeights)
end

function Cell:chooseTileIndex()
  local remaining = love.math.random() * self.sumOfPossibleWeights
  for i = 1, numTiles do
    if self.possible[i] then
      local rf = getFrequency(i - 1)
      if remaining >= rf then
        remaining = remaining - rf
      else
        return i
      end
    end
  end
end

function EntropyCoord:new(x, y, e)
  self.x = x
  self.y = y
  self.e = e
end

function RemovalUpdate:new(x,y,tile)
  self.x = x
  self.y = y
  self.tile = tile
end

function Core:new()
  self.remaining = mapWidth * mapHeight
  self.grid = {}

  -- working table for uncollapsed cells
  self.entropyHeap = {}

  -- working table for propagation
  self.tileRemovals = {}
  
  -- build the cell grid
  for i = 1, mapWidth do
    table.insert(self.grid, {})
    for j = 1, mapHeight do
      local cell = Cell()
      table.insert(self.grid[i], cell)
      local coord = EntropyCoord(i, j, cell:getEntropy())
      table.insert(self.entropyHeap, coord)
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
    -- will this work?
  end
end

function Core:collapseCellAt(x, y)
  local cell = self.grid[x][y]
  local tileIndexToCollapse = cell:chooseTileIndex()
  cell.collapsed = true
  for i = 1, numTiles do
    if tileIndexToCollapse ~= (i - 1) then
      cell.possible[i] = false
      local removal = RemovalUpdate(x, y, i - 1)
      self.tileRemovals.push(removal)
    end
  end
  self.grid[x][y] = cell --necessary?
end

function Core:propagate()

end

function Core:run()
end