local _2afile_2a = "fnl/snap/select/insert.fnl"
local _2amodule_name_2a = "snap.select.insert"
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
  return vim.api.nvim_put({tostring(selection)}, "c", true, true)
end
_2amodule_2a["select"] = select
return _2amodule_2a