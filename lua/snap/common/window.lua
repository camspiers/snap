local _2afile_2a = "fnl/snap/common/window.fnl"
local _2amodule_name_2a = "snap.common.window"
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
local function create(bufnr, _1_)
  local _arg_2_ = _1_
  local width = _arg_2_["width"]
  local height = _arg_2_["height"]
  local row = _arg_2_["row"]
  local col = _arg_2_["col"]
  local focusable = _arg_2_["focusable"]
  local enter = _arg_2_["enter"]
  local title = _arg_2_["title"]
  local _3_
  if (enter == nil) then
    _3_ = false
  else
    _3_ = enter
  end
  local _5_
  if (title ~= nil) then
    _5_ = "center"
  else
    _5_ = nil
  end
  local _7_
  if (title ~= nil) then
    _7_ = string.format(" %s ", title)
  else
    _7_ = nil
  end
  return vim.api.nvim_open_win(bufnr, _3_, {width = width, height = height, row = row, col = col, focusable = focusable, title_pos = _5_, title = _7_, noautocmd = true, relative = "editor", anchor = "NW", style = "minimal", border = {"\226\149\173", "\226\148\128", "\226\149\174", "\226\148\130", "\226\149\175", "\226\148\128", "\226\149\176", "\226\148\130"}})
end
_2amodule_2a["create"] = create
local function update(winnr, _9_)
  local _arg_10_ = _9_
  local width = _arg_10_["width"]
  local height = _arg_10_["height"]
  local row = _arg_10_["row"]
  local col = _arg_10_["col"]
  local focusable = _arg_10_["focusable"]
  if vim.api.nvim_win_is_valid(winnr) then
    return vim.api.nvim_win_set_config(winnr, {width = width, height = height, row = row, col = col, focusable = focusable, relative = "editor"})
  else
    return nil
  end
end
_2amodule_2a["update"] = update
local function close(winnr)
  return vim.api.nvim_win_close(winnr, true)
end
_2amodule_2a["close"] = close
return _2amodule_2a