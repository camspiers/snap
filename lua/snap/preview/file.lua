local _2afile_2a = "fnl/snap/preview/file.fnl"
local snap = require("snap")
local read_file = snap.get("preview.read-file")
local loading = snap.get("loading")
local syntax = snap.get("preview.syntax")
local function _1_(request)
  local load_counter = 0
  local last_time = vim.loop.now()
  local function render_loader()
    if ((vim.loop.now() - last_time) > 500) then
      local function _2_()
        if not request.canceled() then
          last_time = vim.loop.now()
          load_counter = (load_counter + 1)
          return vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, loading(request.width, request.height, load_counter))
        end
      end
      return snap.sync(_2_)
    end
  end
  local path
  local function _2_(...)
    return vim.fn.fnamemodify(tostring(request.selection), ":p", ...)
  end
  path = snap.sync(_2_)
  local preview = read_file(path, render_loader)
  local function _3_()
    if not request.canceled() then
      vim.api.nvim_win_set_option(request.winnr, "cursorline", false)
      vim.api.nvim_win_set_option(request.winnr, "cursorcolumn", false)
      vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, preview)
      return syntax(vim.fn.fnamemodify(tostring(request.selection), ":t"), request.bufnr)
    end
  end
  snap.sync(_3_)
  preview = nil
  return nil
end
return _1_