local _2afile_2a = "fnl/snap/layout/init.fnl"
local _0_0
do
  local name_0_ = "snap.layout"
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
  module_0_["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local _2amodule_2a = _0_0
local _2amodule_name_2a = "snap.layout"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local function lines()
  return vim.api.nvim_get_option("lines")
end
local function columns()
  return vim.api.nvim_get_option("columns")
end
local function middle(total, size)
  return math.floor(((total - size) / 2))
end
local function from_bottom(size, offset)
  return (lines() - size - offset)
end
local function size(_25width, _25height)
  return {height = math.floor((lines() * _25height)), width = math.floor((columns() * _25width))}
end
local function _25centered(_25width, _25height)
  local _let_0_ = size(_25width, _25height)
  local height = _let_0_["height"]
  local width = _let_0_["width"]
  return {col = middle(columns(), width), height = height, row = middle(lines(), height), width = width}
end
local function _25bottom(_25width, _25height)
  local _let_0_ = size(_25width, _25height)
  local height = _let_0_["height"]
  local width = _let_0_["width"]
  return {col = middle(columns(), width), height = height, row = from_bottom(height, 8), width = width}
end
local function _25top(_25width, _25height)
  local _let_0_ = size(_25width, _25height)
  local height = _let_0_["height"]
  local width = _let_0_["width"]
  return {col = middle(columns(), width), height = height, row = 5, width = width}
end
local centered
do
  local v_0_
  do
    local v_0_0
    local function centered0()
      return _25centered(0.9, 0.7)
    end
    v_0_0 = centered0
    _0_0["centered"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["centered"] = v_0_
  centered = v_0_
end
local bottom
do
  local v_0_
  do
    local v_0_0
    local function bottom0()
      return _25bottom(0.8, 0.5)
    end
    v_0_0 = bottom0
    _0_0["bottom"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["bottom"] = v_0_
  bottom = v_0_
end
local top
do
  local v_0_
  do
    local v_0_0
    local function top0()
      return _25top(0.8, 0.5)
    end
    v_0_0 = top0
    _0_0["top"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["top"] = v_0_
  top = v_0_
end
return nil