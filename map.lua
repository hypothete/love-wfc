Map = Object:extend()

function Map:new(filename, width, height, tileSize, tileWidth, tileHeight)
  self.filename = filename
  self.data = nil
  self.spriteBatch = nil
  self.width = width
  self.height = height
  self.tileSize = tileSize
  self.tileWidth = tileWidth
  self.tileHeight = tileHeight
  self.quads = {}
  self:loadTiles()
end

function Map:loadTiles()
  local img = love.graphics.newImage(self.filename)
  img:setFilter('nearest', 'nearest')
  self.spriteBatch = love.graphics.newSpriteBatch(img, self.tileWidth * self.tileHeight, 'static')
  for i = 0, self.tileWidth - 1 do
    for j = 0, self.tileHeight - 1 do
      table.insert(self.quads, love.graphics.newQuad(
        i * self.tileSize,
        j * self.tileSize,
        self.tileSize,
        self.tileSize,
        img:getWidth(),
        img:getHeight()
      ))
    end
  end
end

function Map:updateTiles(data)
  self.data = data
  self.spriteBatch:clear()
  for i = 1, self.width do
    for j = 1, self.height do
      self.spriteBatch:add(
        self.quads[self.data[i][j] + 1],
        (i - 1) * self.tileSize,
        (j - 1) * self.tileSize
      )
    end
  end
  self.spriteBatch:flush()
end