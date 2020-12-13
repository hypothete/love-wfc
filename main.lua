-- WFC Renderer

Object = require 'libraries/classic'
-- https://github.com/rxi/classic

require('map')
require('weights')
require('core')

core = nil
weights = nil
map = nil

function love.load()
  love.math.setRandomSeed(37)
  weights = Weights('assets/data/simple.txt', 2 * 2)
  map = Map('assets/images/simple.png', 40, 30, 16, 2, 2)
  -- weights = Weights('assets/data/garden.txt', 32 * 32)
  -- map = Map('assets/images/garden.png', 40, 30, 16, 8, 8)
  core = Core(map, weights)
  map:updateTiles(core.final)
end

function love.update()

end

function love.draw()
  love.graphics.draw(map.spriteBatch)
end