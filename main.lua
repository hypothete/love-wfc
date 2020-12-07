Object = require 'libraries/classic'

blobs = {}

Blob = Object.extend(Object)

function Blob.new(self, x, y)
  self.x = x;
  self.y = y;
end

function Blob.draw(self)
  love.graphics.circle("line", self.x, self.y, 10)
end

function makeRandomBlob()
  local blob = Blob(
    love.math.random() * 320,
    love.math.random() * 240
  )
  return blob
end

function love.load()
  love.graphics.setColor(0, 1, 0)
  --love.graphics.setLineStyle("rough")
end

function love.update()
  local randomBlob = makeRandomBlob()
  table.insert(blobs, randomBlob)
end

function love.draw()
  local vertices = {}
  for i=1, #blobs do
    blobs[i]:draw()
  end
end