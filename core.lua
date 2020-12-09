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