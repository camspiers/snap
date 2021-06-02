local _2afile_2a = "fnl/snap/layout/init.fnl"
local _0_
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
local _2amodule_name_2a = "snap.layout"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
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
local _25centered
do
  local v_0_
  do
    local v_0_0
    local function _25centered0(_25width, _25height)
      local _let_0_ = size(_25width, _25height)
      local height = _let_0_["height"]
      local width = _let_0_["width"]
      return {col = middle(columns(), width), height = height, row = middle(lines(), height), width = width}
    end
    v_0_0 = _25centered0
    _0_["%centered"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["%centered"] = v_0_
  _25centered = v_0_
end
local _25bottom
do
  local v_0_
  do
    local v_0_0
    local function _25bottom0(_25width, _25height)
      local _let_0_ = size(_25width, _25height)
      local height = _let_0_["height"]
      local width = _let_0_["width"]
      return {col = middle(columns(), width), height = height, row = from_bottom(height, 8), width = width}
    end
    v_0_0 = _25bottom0
    _0_["%bottom"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["%bottom"] = v_0_
  _25bottom = v_0_
end
local _25top
do
  local v_0_
  do
    local v_0_0
    local function _25top0(_25width, _25height)
      local _let_0_ = size(_25width, _25height)
      local height = _let_0_["height"]
      local width = _let_0_["width"]
      return {col = middle(columns(), width), height = height, row = 5, width = width}
    end
    v_0_0 = _25top0
    _0_["%top"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["%top"] = v_0_
  _25top = v_0_
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
    _0_["centered"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["centered"] = v_0_
  centered = v_0_
end
local bottom
do
  local v_0_
  do
    local v_0_0
    local function bottom0()
      return _25bottom(0.9, 0.7)
    end
    v_0_0 = bottom0
    _0_["bottom"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["bottom"] = v_0_
  bottom = v_0_
end
local top
do
  local v_0_
  do
    local v_0_0
    local function top0()
      return _25top(0.9, 0.7)
    end
    v_0_0 = top0
    _0_["top"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["top"] = v_0_
  top = v_0_
end
return nil