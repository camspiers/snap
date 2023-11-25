local _2afile_2a = "fnl/snap/select/file.fnl"
local file = require("snap.select.common.file")
local select
local function _1_(selection)
  return {filename = tostring(selection)}
end
select = file(_1_)
local function multiselect(selections, winnr)
  for index, selection in ipairs(selections) do
    local function _2_()
      if (#selections == index) then
        return winnr
      else
        return false
      end
    end
    select(selection, _2_())
  end
  return nil
end
return {multiselect = multiselect, select = select}