local _2afile_2a = "fnl/snap/select/currentbuffer.fnl"
local _2amodule_name_2a = "snap.select.currentbuffer"
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
local function select(result, winnr)
  local buffer = vim.fn.bufnr(result.filename, true)
  vim.api.nvim_buf_set_option(buffer, "buflisted", true)
  vim.api.nvim_win_set_buf(winnr, buffer)
  return vim.api.nvim_win_set_cursor(winnr, {result.row, 0})
end
_2amodule_2a["select"] = select
return _2amodule_2a