-- core algorithm

Core = Object:extend()
Cell = Object:extend()

function Cell:new()
  self.possible = {}
  -- set all options to true
  for i=1, numTiles do
    table.insert(self.possible, true)
  end
  self.sumOfPossibleTileWeights = self:totalPossibleFreq()
  self.sumOfPossibleTileWeightsLogWeights = 0
  for i=1, numTiles do
    local _, rl = getFrequency(i - 1)
    self.sumOfPossibleTileWeightsLogWeights = self.sumOfPossibleTileWeightsLogWeights + rl
  end
  
end

function Cell:totalPossibleFreq()
  local total = 0
  for i=1, numTiles do
    if self.possible[i] then
      total = total + getFrequency(i - 1)
    end
  end
  return total
end

function Cell:removeTile(tileIndex)
  self.possible[tileIndex + 1] = false
  local rf, rl = getFrequency(tileIndex)
  self.sumOfPossibleTileWeights = self.sumOfPossibleTileWeights - rf
  self.sumOfPossibleTileWeightsLogWeights = self.sumOfPossibleTileWeightsLogWeights - rl
end

function Cell:getEntropy()
  return math.log(self.sumOfPossibleTileWeights, 2) -
    (self.sumOfPossibleTileWeightsLogWeights / self.sumOfPossibleTileWeights)
end

function Core:new()
  self.remaining = mapWidth * mapHeight
  self.weights = weights
  self.grid = {}
  for i = 1, mapWidth do
    table.insert(self.grid, {})
    for j = 1, mapHeight do
      local cell = Cell()
      table.insert(self.grid[i], cell)
    end
  end
end

function Core:chooseNextCell()
end

function Core:collapseCell()
end

function Core:propagate()
end

function Core:run()
end