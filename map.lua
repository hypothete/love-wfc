tileSize = 16
numTiles = 8 * 8
mapWidth = 20
mapHeight = 15
mapTiles = nil
mapTileQuads = {}
map = {}

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
  for i = 1, mapWidth do
    table.insert(map, {})
    for j = 1, mapHeight do
      table.insert(map[i], 0)
    end
  end
end

function updateMapTiles()
  mapTiles:clear()
  for i = 1, mapWidth do
    for j = 1, mapHeight do
      mapTiles:add(
        mapTileQuads[map[i][j] + 1],
        (i - 1) * tileSize,
        (j - 1) * tileSize
      )
    end
  end
  mapTiles:flush()
end