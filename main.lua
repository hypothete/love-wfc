-- WFC Renderer

require('map')
require('weights')

function love.load()
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