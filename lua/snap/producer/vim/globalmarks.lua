local _2afile_2a = "fnl/snap/producer/vim/globalmarks.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local function get_marks()
  local function _1_(mark)
    return snap.with_metas(string.format("%s = %s:%d:%d", mark.mark, mark.file, mark.pos[2], mark.pos[3]), mark)
  end
  return vim.tbl_map(_1_, vim.fn.getmarklist())
end
local function _2_()
  return snap.sync(get_marks)
end
return _2_