local _2afile_2a = "fnl/snap/producer/vim/currentbuffer.fnl"
local snap = require("snap")
local function _2_(_1_)
  local _arg_0_ = _1_
  local winnr = _arg_0_["winnr"]
  local bufnr
  local function _3_(...)
    return vim.api.nvim_win_get_buf(winnr, ...)
  end
  bufnr = snap.sync(_3_)
  local filename
  local function _4_(...)
    return vim.api.nvim_buf_get_name(bufnr, ...)
  end
  filename = snap.sync(_4_)
  local contents
  local function _5_(...)
    return vim.api.nvim_buf_get_lines(bufnr, 0, -1, false, ...)
  end
  contents = snap.sync(_5_)
  local results = {}
  for row, line in ipairs(contents) do
    table.insert(results, snap.with_metas(line, {filename = filename, row = row}))
  end
  return coroutine.yield(results)
end
return _2_