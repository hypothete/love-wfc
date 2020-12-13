-- weight and weights casses for map gen

Weight = Object:extend()
Weights = Object:extend()

function Weight:new(id, f, n, s, e, w)
  self.id = tonumber(id)
  -- overall frequency
  self.freq = tonumber(f)
  self.fflog2 = self.freq * math.log(self.freq, 2)
  if self.fflog2 ~= self.fflog2 then
    -- nan
    self.fflog2 = 0
  end
  -- compatible tiles
  self.n = self:splitOnCommas(n)
  self.s = self:splitOnCommas(s)
  self.e = self:splitOnCommas(e)
  self.w = self:splitOnCommas(w)
end

function Weight:splitOnCommas(cstr)
  local ctable = {}
  if not cstr then return ctable end
  for token in string.gmatch(cstr, '(%d+)') do
      table.insert(ctable, tonumber(token))
  end
  return ctable
end

function Weight:print()
  print('id', self.id)
  print('freq', self.freq)
  print('fflog2', self.fflog2)
  print('n', #self.n)
  print('s', #self.s)
  print('e', #self.e)
  print('w', #self.w)
  print()
end

function Weights:new(filename)
  self.filename = filename
  self.weights = {}
  self:loadWeights()
end

function Weights:readWeightsFile()
  local lines = {}
  for line in io.lines(self.filename) do
    lines[#lines + 1] = line
  end
  return lines
end

function Weights:parseLine(line)
  local _, _, i, f, n, s, e, w = string.find(line, 'i(%d+),f(%d+),n(%S*),s(%S*),e(%S*),w(%S*)')
  local weight = Weight(i, f, n, s, e, w)
  return weight
end

function Weights:loadWeights()
  local lines = self:readWeightsFile()
  for i=1, #lines do
      local weight = self:parseLine(lines[i])
      table.insert(self.weights, weight)
  end
end

function Weights:getWeightById(tileId)
  if tileId == nil then
    error('tileId is nil')
  end
  for i=1, #self.weights do
    if self.weights[i].id == tileId then
      return self.weights[i]
    end
  end
  error('Got invalid tileId')
end

function Weights:getFrequency(tileId)
  local weight = self:getWeightById(tileId)
  if weight then
    return weight.freq, weight.fflog2
  else
    return -1, -1
  end
end