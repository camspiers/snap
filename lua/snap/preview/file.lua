local _2afile_2a = "fnl/snap/preview/file.fnl"
local snap = require("snap")
local get = snap.get("preview.get")
local loading = snap.get("loading")
local function _1_(request)
  local function _2_()
    return vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, loading(request.width, request.height, 4))
  end
  snap.sync(_2_)
  local path
  local function _3_(...)
    return vim.fn.fnamemodify(tostring(request.selection), ":p", ...)
  end
  path = snap.sync(_3_)
  local preview = get(path)
  local function _4_()
    if not request.canceled() then
      vim.api.nvim_win_set_option(request.winnr, "cursorline", false)
      vim.api.nvim_win_set_option(request.winnr, "cursorcolumn", false)
      vim.api.nvim_buf_set_name(request.bufnr, "")
      vim.api.nvim_buf_set_option(request.bufnr, "filetype", "")
      vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, preview)
      preview = nil
      return nil
    end
  end
  snap.sync(_4_)
  local function _5_()
    if not request.canceled() then
      local fake_path = (vim.fn.tempname() .. "%" .. vim.fn.fnamemodify(tostring(request.selection), ":p:gs?/?%?"))
      vim.api.nvim_buf_set_name(request.bufnr, fake_path)
      local function _6_()
        return vim.api.nvim_command("filetype detect")
      end
      vim.api.nvim_buf_call(request.bufnr, _6_)
      local highlighter = vim.treesitter.highlighter.active[request.bufnr]
      if highlighter then
        return highlighter:destroy()
      end
    end
  end
  snap.sync(_5_)
  preview = nil
  return nil
end
return _1_