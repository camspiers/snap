local _2afile_2a = "fnl/snap/common/string.fnl"
local _2amodule_name_2a = "snap.common.string"
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
local function split(str)
  local tbl_17_auto = {}
  local i_18_auto = #tbl_17_auto
  for _, line in ipairs(vim.split(str, "\n", true)) do
    local val_19_auto
    do
      local trimmed = vim.trim(line)
      if (trimmed ~= "") then
        val_19_auto = trimmed
      else
        val_19_auto = nil
      end
    end
    if (nil ~= val_19_auto) then
      i_18_auto = (i_18_auto + 1)
      do end (tbl_17_auto)[i_18_auto] = val_19_auto
    else
    end
  end
  return tbl_17_auto
end
_2amodule_2a["split"] = split
return _2amodule_2a