-- WFC Renderer

require('map')
require('weights')
require('core')

function love.load()
  love.math.setRandomSeed(37)
  loadMap()
  loadTiles()
  updateMapTiles()
  loadWeights()
end

function love.update()

end

function love.draw()
  love.graphics.draw(mapTiles)
end