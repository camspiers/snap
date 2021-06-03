local _2afile_2a = "fnl/snap/loading/init.fnl"
local _0_
do
  local name_0_ = "snap.loading"
  local module_0_
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  do end (module_0_)["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  do end (package.loaded)[name_0_] = module_0_
  _0_ = module_0_
end
local autoload
local function _1_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _1_
local function _2_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _2_()
    return {}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local _2amodule_2a = _0_
local _2amodule_name_2a = "snap.loading"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local function center_with_text_width(text, text_width, width)
  local space = string.rep(" ", ((width - text_width) / 2))
  return (space .. text .. space)
end
local function center(text, width)
  return center_with_text_width(text, string.len(text), width)
end
local function _3_(width, height, counter)
  local dots = string.rep(".", (counter % 5))
  local space = string.rep(" ", (5 - string.len(dots)))
  local loading_with_dots = ("\226\148\130" .. space .. dots .. " Loading " .. dots .. space .. "\226\148\130")
  local text_width = string.len(loading_with_dots)
  local loading = {}
  for _ = 1, (height / 2) do
    table.insert(loading, "")
  end
  table.insert(loading, center_with_text_width(("\226\149\173" .. string.rep("\226\148\128", 19) .. "\226\149\174"), text_width, width))
  table.insert(loading, center(loading_with_dots, width))
  table.insert(loading, center_with_text_width(("\226\149\176" .. string.rep("\226\148\128", 19) .. "\226\149\175"), text_width, width))
  return loading
end
return _3_