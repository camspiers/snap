local _2afile_2a = "fnl/snap/preview/vimgrep.fnl"
local snap = require("snap")
local loading = snap.get("loading")
local read_file = snap.get("preview.read-file")
local parse = snap.get("common.vimgrep.parse")
local syntax = snap.get("preview.syntax")
local function _1_(request)
  local load_counter = 0
  local last_time = 0
  local function render_loader()
    if ((vim.loop.now() - last_time) > 500) then
      local function _2_()
        if not request.canceled() then
          last_time = vim.loop.now()
          load_counter = (load_counter + 1)
          return vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, loading(request.width, request.height, load_counter))
        else
          return nil
        end
      end
      return snap.sync(_2_)
    else
      return nil
    end
  end
  local selection = parse(tostring(request.selection))
  local path
  local function _6_()
    local _5_ = selection.filename
    local function _7_(...)
      return vim.fn.fnamemodify(_5_, ":p", ...)
    end
    return _7_
  end
  path = snap.sync(_6_())
  local preview = read_file(path, render_loader)
  local preview_size = #preview
  local function _8_()
    if not request.canceled() then
      vim.api.nvim_win_set_option(request.winnr, "cursorline", true)
      vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, preview)
      if (selection.lnum <= preview_size) then
        vim.api.nvim_win_set_cursor(request.winnr, {selection.lnum, (selection.col - 1)})
      else
      end
      return syntax(path, vim.fn.fnamemodify(selection.filename, ":t"), request.bufnr)
    else
      return nil
    end
  end
  snap.sync(_8_)
  preview = nil
  return nil
end
return _1_