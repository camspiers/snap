local _2afile_2a = "fnl/snap/preview/jumplist.fnl"
local snap = require("snap")
local parse = snap.get("common.vimgrep.parse")
local function _1_(request)
  local function _2_()
    if not request.canceled() then
      vim.api.nvim_win_set_option(request.winnr, "cursorline", true)
      vim.api.nvim_win_set_option(request.winnr, "cursorcolumn", true)
      vim.api.nvim_win_set_buf(request.winnr, request.selection.bufnr)
      local total_lines = #vim.api.nvim_buf_get_lines(request.selection.bufnr, 0, -1, false)
      return vim.api.nvim_win_set_cursor(request.winnr, {math.min(request.selection.lnum, total_lines), 0})
    else
      return nil
    end
  end
  return snap.sync(_2_)
end
return _1_