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
  weights = Weights('assets/data/garden.txt')
  map = Map('assets/images/tiles.png', 20, 15, 16, 8, 8)
  core = Core(map, weights)
  map:updateTiles(core.final)
end

function love.update()

end

function love.draw()
  love.graphics.draw(map.spriteBatch)
end