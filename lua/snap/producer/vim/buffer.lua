local _2afile_2a = "fnl/snap/producer/vim/buffer.fnl"
local function get_buffers()
  local function _1_(_241)
    return vim.fn.bufname(_241)
  end
  local function _2_(_241)
    return ((vim.fn.bufname(_241) ~= "") and (vim.fn.buflisted(_241) == 1) and (vim.fn.bufexists(_241) == 1))
  end
  return vim.tbl_map(_1_, vim.tbl_filter(_2_, vim.api.nvim_list_bufs()))
end
local snap = require("snap")
local function _1_()
  return snap.sync(get_buffers)
end
return _1_