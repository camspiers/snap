local _2afile_2a = "fnl/snap/select/vim/currentbuffer.fnl"
local _2amodule_name_2a = "snap.select.vim.currentbuffer"
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
local select_file = require("snap.select.common.file")
do end (_2amodule_locals_2a)["select-file"] = select_file
local select
local function _1_(selection)
  return {path = selection.filename, lnum = selection.row}
end
select = select_file(_1_)
do end (_2amodule_2a)["select"] = select
return _2amodule_2a