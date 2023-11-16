local _2afile_2a = "fnl/snap/preview/vimgrep.fnl"
local snap = require("snap")
local parse = snap.get("common.vimgrep.parse")
local function _1_(selection)
  local parsed_selection = parse(tostring(selection))
  local function _3_()
    local _2_ = parsed_selection.filename
    local function _4_(...)
      return vim.fn.fnamemodify(_2_, ":p", ...)
    end
    return _4_
  end
  return {path = snap.sync(_3_()), line = parsed_selection.lnum, column = parsed_selection.col}
end
return snap.get("preview.common.create-file-preview")(_1_)