-- core algorithm

Core = Object:extend()
Cell = Object:extend()

function Cell:new()
  self.possible = {}
  -- set all options to true
  for i=1, numTiles do
    table.insert(self.possible, true)
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

function Cell:getEntropy()
  local totalWeight = self:totalPossibleFreq()
  local sumOfWeightLogWeight = 0
  for i=1, numTiles do
    if self.possible[i] then
      local rf = getFrequency(i - 1)
      sumOfWeightLogWeight = sumOfWeightLogWeight + rf * math.log(rf, 2)
    end
  end
  return math.log(totalWeight, 2) - (sumOfWeightLogWeight / totalWeight)
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