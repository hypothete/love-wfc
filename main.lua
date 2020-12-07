-- WFC Renderer

tileSize = 16
numTiles = 8 * 8
mapWidth = 20
mapHeight = 15

function loadTiles()
  local img = love.graphics.newImage('assets/images/tiles.png')
  img:setFilter('nearest', 'nearest')
  mapTiles = love.graphics.newSpriteBatch(img, numTiles, 'static')
  -- make quads
  mapTileQuads = {}
  for i = 0, 7 do
    for j = 0, 7 do
      table.insert(mapTileQuads, love.graphics.newQuad(
        i * tileSize,
        j * tileSize,
        tileSize,
        tileSize,
        img:getWidth(),
        img:getHeight()
      ))
    end
  end
end

function loadMap()
  map = {}
  for i = 1, mapWidth do
    table.insert(map, {})
    for j = 1, mapHeight do
      table.insert(map[i], 1)
    end
  end
end

function updateMapTiles()
  mapTiles:clear()
  for i = 1, mapWidth do
    for j = 1, mapHeight do
      mapTiles:add(
        mapTileQuads[map[i][j]],
        (i - 1) * tileSize,
        (j - 1) * tileSize
      )
    end
  end
  mapTiles:flush()
end

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