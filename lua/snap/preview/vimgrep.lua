local _2afile_2a = "fnl/snap/preview/vimgrep.fnl"
local snap = require("snap")
local get = snap.get("preview.get")
local parse = snap.get("common.vimgrep.parse")
local function _1_(request)
  local selection = parse(tostring(request.selection))
  local path
  local function _2_(...)
    return vim.fn.fnamemodify(selection.filename, ":p", ...)
  end
  path = snap.sync(_2_)
  local preview = get(path)
  local preview_size = #preview
  local function _3_()
    if not request.canceled() then
      vim.api.nvim_win_set_option(request.winnr, "cursorline", true)
      vim.api.nvim_win_set_option(request.winnr, "cursorcolumn", true)
      vim.api.nvim_buf_set_option(request.bufnr, "filetype", "")
      vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, preview)
      preview = nil
      return nil
    end
  end
  snap.sync(_3_)
  local function _4_()
    if not request.canceled() then
      local fake_path = (vim.fn.tempname() .. "%" .. vim.fn.fnamemodify(selection.filename, ":p:gs?/?%?"))
      vim.api.nvim_buf_set_name(request.bufnr, fake_path)
      local function _5_()
        return vim.api.nvim_command("filetype detect")
      end
      vim.api.nvim_buf_call(request.bufnr, _5_)
      local highlighter = vim.treesitter.highlighter.active[request.bufnr]
      if highlighter then
        highlighter:destroy()
      end
      if (selection.lnum <= preview_size) then
        return vim.api.nvim_win_set_cursor(request.winnr, {selection.lnum, (selection.col - 1)})
      end
    end
  end
  snap.sync(_4_)
  preview = nil
  return nil
end
return _1_