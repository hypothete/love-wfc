-- WFC Renderer

Object = require 'libraries/classic'
-- https://github.com/rxi/classic

require('map')
require('weights')
require('core')

core = nil
weights = nil
map = nil

function rebuildCore()
  core:setup()
  -- core:presetCellAt(9, 7, 12)
  -- core:presetCellAt(10, 7, 13)
  -- core:presetCellAt(9, 8, 20)
  -- core:presetCellAt(10, 8, 21)

  if not pcall(function () core:run() end) then
    rebuildCore()
  else
    map:updateTiles(core.final)
  end
end

function love.load()
  -- love.math.setRandomSeed(37)

  -- weights = Weights('assets/data/simple.txt')
  -- map = Map('assets/images/simple.png', 40, 30, 16, 2, 2)

  weights = Weights('assets/data/garden.txt')
  map = Map('assets/images/garden.png', 20, 15, 16, 8, 8)
  core = Core(map, weights)
  rebuildCore()
end

function love.update()

end

function love.keyreleased(key)
  if key == 'space' then
    rebuildCore()
  end
end

function love.draw()
  love.graphics.draw(map.spriteBatch)
end