local _2afile_2a = "fnl/snap/preview/common/file.fnl"
local snap = require("snap")
local loading = snap.get("loading")
local read_file = snap.get("preview.common.read-file")
local parse = snap.get("common.vimgrep.parse")
local syntax = snap.get("preview.common.syntax")
local tbl = snap.get("common.tbl")
local function _1_(get_file_data)
  local function _2_(request)
    local load_counter = 0
    local last_time = vim.loop.now()
    local max_length = 500
    local function render_loader()
      if ((vim.loop.now() - last_time) > 500) then
        local function _3_()
          if not request.canceled() then
            last_time = vim.loop.now()
            load_counter = (load_counter + 1)
            return vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, loading(request.width, request.height, load_counter))
          else
            return nil
          end
        end
        return snap.sync(_3_)
      else
        return nil
      end
    end
    local file_data = get_file_data(request.selection)
    local file_name = vim.fn.fnamemodify(file_data.path, ":t")
    local preview = read_file(file_data.path, render_loader)
    local preview_size = #preview
    local function _6_()
      if not request.canceled() then
        vim.api.nvim_win_set_option(request.winnr, "cursorline", true)
        vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, preview)
        if ((file_data.line ~= nil) and (file_data.line <= preview_size)) then
          vim.api.nvim_win_set_cursor(request.winnr, {file_data.line, (file_data.column - 1)})
        else
        end
        if (tbl["max-length"](preview) < max_length) then
          return syntax(file_name, request.bufnr)
        else
          return nil
        end
      else
        return nil
      end
    end
    snap.sync(_6_)
    preview = nil
    return nil
  end
  return _2_
end
return _1_