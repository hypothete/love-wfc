Object = require 'libraries/classic'

weights = {}

Weight = Object:extend()

function splitOnCommas(cstr)
  local ctable = {}
  if not cstr then return ctable end
  for token in string.gmatch(cstr, '(%d+),') do
      table.insert(ctable, token)
  end
  return ctable
end

function Weight:new(id, n, s, e, w)
  self.id = id;
  self.n = splitOnCommas(n);
  self.s = splitOnCommas(s);
  self.e = splitOnCommas(e);
  self.w = splitOnCommas(w);
end

function Weight:print()
  print('id', self.id)
  print('n', #self.n)
  print('s', #self.s)
  print('e', #self.e)
  print('w', #self.w)
  print()
end

function readWeightsFile()
  local lines = {}
  for line in io.lines('assets/data/garden.txt') do
    -- print(line)
    lines[#lines + 1] = line
  end
  return lines
end

function parseLine(line)
  local _, _, i, n, s, e, w = string.find(line, 'i(%d+),n(%S+),s(%S+),e(%S+),w(%S+)')
  local weight = Weight(i, n, s, e, w)
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