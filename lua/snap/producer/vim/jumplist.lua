local _2afile_2a = "fnl/snap/producer/vim/jumplist.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local function get_jumplist()
  local function _1_(item)
    return snap.with_metas(string.format("%s:%s:%s", (item.filename or vim.api.nvim_buf_get_name(item.bufnr)), item.lnum, item.col), item)
  end
  local function _2_(_241)
    return vim.api.nvim_buf_is_valid(_241.bufnr)
  end
  return vim.tbl_map(_1_, vim.tbl_filter(_2_, tbl.first(vim.fn.getjumplist())))
end
local function _1_()
  return snap.sync(get_jumplist)
end
return _1_