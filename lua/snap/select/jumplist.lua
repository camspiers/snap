local _2afile_2a = "fnl/snap/select/jumplist.fnl"
local _2amodule_name_2a = "snap.select.jumplist"
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
local function select(selection, winnr)
  local _let_1_ = selection
  local bufnr = _let_1_["bufnr"]
  local lnum = _let_1_["lnum"]
  local col = _let_1_["col"]
  vim.api.nvim_win_set_buf(winnr, bufnr)
  vim.api.nvim_win_set_option(winnr, "relativenumber", true)
  return vim.api.nvim_win_set_cursor(winnr, {lnum, col})
end
_2amodule_2a["select"] = select
return _2amodule_2a