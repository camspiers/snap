local _2afile_2a = "fnl/snap/layout/init.fnl"
local _2amodule_name_2a = "snap.layout"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local function lines()
  return vim.api.nvim_get_option("lines")
end
_2amodule_2a["lines"] = lines
local function columns()
  return vim.api.nvim_get_option("columns")
end
_2amodule_2a["columns"] = columns
local function percent(size, percent0)
  return math.floor((size * percent0))
end
_2amodule_2a["percent"] = percent
local function size(_25width, _25height)
  return {width = math.floor((columns() * _25width)), height = math.floor((lines() * _25height))}
end
local function from_bottom(size0, offset)
  return (lines() - size0 - offset)
end
local function middle(total, size0)
  return math.floor(((total - size0) / 2))
end
_2amodule_2a["middle"] = middle
local function _25centered(_25width, _25height)
  local _let_1_ = size(_25width, _25height)
  local width = _let_1_["width"]
  local height = _let_1_["height"]
  return {width = width, height = height, row = middle(lines(), height), col = middle(columns(), width)}
end
_2amodule_2a["%centered"] = _25centered
local function _25bottom(_25width, _25height)
  local _let_2_ = size(_25width, _25height)
  local width = _let_2_["width"]
  local height = _let_2_["height"]
  return {width = width, height = height, row = from_bottom(height, 8), col = middle(columns(), width)}
end
_2amodule_2a["%bottom"] = _25bottom
local function _25top(_25width, _25height)
  local _let_3_ = size(_25width, _25height)
  local width = _let_3_["width"]
  local height = _let_3_["height"]
  return {width = width, height = height, row = 5, col = middle(columns(), width)}
end
_2amodule_2a["%top"] = _25top
local function centered()
  return _25centered(0.9, 0.7)
end
_2amodule_2a["centered"] = centered
local function bottom()
  local lines0 = vim.api.nvim_get_option("lines")
  local height = math.floor((lines0 * 0.5))
  local width = vim.api.nvim_get_option("columns")
  local col = 0
  local row = (lines0 - height - 4)
  return {width = width, height = height, col = col, row = row}
end
_2amodule_2a["bottom"] = bottom
local function top()
  return _25top(0.9, 0.7)
end
_2amodule_2a["top"] = top
return _2amodule_2a