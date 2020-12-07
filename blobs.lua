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
