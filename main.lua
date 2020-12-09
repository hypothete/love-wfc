-- WFC Renderer

require('map')
require('weights')
require('core')

function love.load()
  loadMap()
  loadTiles()
  updateMapTiles()
end

function love.update()

end

function love.draw()
  love.graphics.draw(mapTiles)
end