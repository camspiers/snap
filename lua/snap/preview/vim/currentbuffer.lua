local _2afile_2a = "fnl/snap/preview/vim/currentbuffer.fnl"
local snap = require("snap")
local function _1_(selection)
  local function _3_()
    local _2_ = selection.filename
    local function _4_(...)
      return vim.fn.fnamemodify(_2_, ":p", ...)
    end
    return _4_
  end
  return {path = snap.sync(_3_()), line = selection.row, column = 1}
end
return snap.get("preview.common.create-file-preview")(_1_)