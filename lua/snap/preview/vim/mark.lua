local _2afile_2a = "fnl/snap/preview/vim/mark.fnl"
local snap = require("snap")
local function _1_(selection)
  local function _3_()
    local _2_ = selection.file
    local function _4_(...)
      return vim.fn.fnamemodify(_2_, ":p", ...)
    end
    return _4_
  end
  return {path = snap.sync(_3_()), line = selection.pos[2], column = selection.pos[3]}
end
return snap.get("preview.common.create-file-preview")(_1_)