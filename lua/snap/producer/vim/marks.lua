local _2afile_2a = "fnl/snap/producer/vim/marks.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local function get_marks(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local function _1_(mark)
    local lnum = mark.pos[2]
    local content = (vim.api.nvim_buf_get_lines(bufnr, (lnum - 1), lnum, false))[1]
    mark["file"] = vim.api.nvim_buf_get_name(bufnr)
    return snap.with_metas(string.format("%s : %s", mark.mark, content), mark)
  end
  return vim.tbl_map(_1_, vim.fn.getmarklist(bufnr))
end
local function _4_(_2_)
  local _arg_3_ = _2_
  local winnr = _arg_3_["winnr"]
  local function _5_(...)
    return get_marks(winnr, ...)
  end
  return snap.sync(_5_)
end
return _4_