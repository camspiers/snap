local _2afile_2a = "fnl/snap/producer/oldfile.fnl"
local function get_oldfiles()
  local function _1_(_241)
    return (vim.fn.empty(vim.fn.glob(_241)) == 0)
  end
  return vim.tbl_filter(_1_, vim.v.oldfiles)
end
local snap = require("snap")
local function _1_()
  return snap.yield(get_oldfiles)
end
return _1_