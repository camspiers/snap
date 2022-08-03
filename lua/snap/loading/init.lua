local _2afile_2a = "fnl/snap/loading/init.fnl"
local function center_with_text_width(text, text_width, width)
  local space = string.rep(" ", ((width - text_width) / 2))
  return (space .. text)
end
local function center(text, width)
  return center_with_text_width(text, string.len(text), width)
end
local function _1_(width, height, counter)
  local dots = string.rep(".", (counter % 5))
  local space = string.rep(" ", (5 - string.len(dots)))
  local loading_with_dots = ("\226\148\130" .. space .. dots .. " Loading " .. dots .. space .. "\226\148\130")
  local text_width = string.len(loading_with_dots)
  local loading = {}
  for _ = 1, (math.floor((height / 2)) - 1) do
    table.insert(loading, "")
  end
  table.insert(loading, center_with_text_width(("\226\149\173" .. string.rep("\226\148\128", 19) .. "\226\149\174"), text_width, width))
  table.insert(loading, center(loading_with_dots, width))
  table.insert(loading, center_with_text_width(("\226\149\176" .. string.rep("\226\148\128", 19) .. "\226\149\175"), text_width, width))
  return loading
end
return _1_