local _2afile_2a = "fnl/snap/select/vimgrep.fnl"
local _2amodule_name_2a = "snap.select.vimgrep"
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
local parse, select_file = require("snap.common.vimgrep.parse"), require("snap.select.common.file")
do end (_2amodule_locals_2a)["parse"] = parse
_2amodule_locals_2a["select-file"] = select_file
local function multiselect(selections, winnr)
  vim.fn.setqflist(vim.tbl_map(parse, selections))
  vim.api.nvim_command("copen")
  return vim.api.nvim_command("cfirst")
end
_2amodule_2a["multiselect"] = multiselect
local select
local function _1_(selection)
  local _let_2_ = parse(selection)
  local filename = _let_2_["filename"]
  local lnum = _let_2_["lnum"]
  local col = _let_2_["col"]
  return {path = filename, lnum = lnum, col = col}
end
select = select_file(_1_)
do end (_2amodule_2a)["select"] = select
return _2amodule_2a