Object = require 'libraries/classic'
-- https://github.com/rxi/classic

weights = {}

Weight = Object:extend()

function splitOnCommas(cstr)
  local ctable = {}
  if not cstr then return ctable end
  for token in string.gmatch(cstr, '(%d+),') do
      table.insert(ctable, tonumber(token))
  end
  return ctable
end

function Weight:new(id, f, n, s, e, w)
  self.id = id;
  self.freq = tonumber(f);
  self.fflog2 = self.freq * math.log(self.freq, 2)
  self.n = splitOnCommas(n);
  self.s = splitOnCommas(s);
  self.e = splitOnCommas(e);
  self.w = splitOnCommas(w);
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

function readWeightsFile()
  local lines = {}
  for line in io.lines('assets/data/garden.txt') do
    lines[#lines + 1] = line
  end
  return lines
end

function parseLine(line)
  local _, _, i, f, n, s, e, w = string.find(line, 'i(%d+),f(%d+),n(%S+),s(%S+),e(%S+),w(%S+)')
  local weight = Weight(i, f, n, s, e, w)
  return weight
end

function loadWeights()
  local lines = readWeightsFile()
  for i=1, #lines do
      local weight = parseLine(lines[i])
      weight:print()
      table.insert(weights, weight)
  end
end

function getFrequency(tileId)
  for i=1, #weights do
      if weights[i].id == tileId then
        return weights[i].freq, weights[i].fflog2;
      end
  end
  return -1, -1
end