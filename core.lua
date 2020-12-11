-- core algorithm

Core = Object:extend()
Cell = Object:extend()
EntropyCoord = Object:extend()

function Cell:new()
  self.possible = {}
  self.sumOfPossibleWeights = 0
  self.sumOfPossibleWeightsLogWeights = 0
  -- set all options to true
  -- set all weights to max
  for i=1, numTiles do
    table.insert(self.possible, true)
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

function Core:new()
  self.remaining = mapWidth * mapHeight
  self.grid = {}
  -- working table for uncollapsed cells
  self.entropyHeap = {}
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
    cell.possible[i] = tileIndexToCollapse == (i - 1)
  end
end

function Core:propagate()
end

function Core:run()
end