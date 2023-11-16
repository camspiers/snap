local _2afile_2a = "fnl/snap/select/file.fnl"
local _2amodule_name_2a = "snap.select.file"
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
local function multiselect(selections, winnr)
  for index, selection in ipairs(selections) do
    local function _1_()
      if (#selections == index) then
        return winnr
      else
        return false
      end
    end
    select(selection, _1_())
  end
  return nil
end
_2amodule_2a["multiselect"] = multiselect
local select
local function _2_(selection)
  return {path = tostring(selection)}
end
select = select_file(_2_)
do end (_2amodule_2a)["select"] = select
return _2amodule_2a