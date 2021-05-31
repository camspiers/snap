local _2afile_2a = "fnl/snap/preview/file.fnl"
local snap = require("snap")
local get = snap.get("preview.get")
local function _1_(request)
  local path
  local function _2_(...)
    return vim.fn.fnamemodify(tostring(request.selection), ":p", ...)
  end
  path = snap.sync(_2_)
  local preview = get(path)
  local function _3_()
    if not request.canceled() then
      vim.api.nvim_win_set_option(request.winnr, "cursorline", false)
      vim.api.nvim_win_set_option(request.winnr, "cursorcolumn", false)
      vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, preview)
      preview = nil
      return nil
    end
  end
  snap.sync(_3_)
  local function _4_()
    if not request.canceled() then
      local fake_path = (vim.fn.tempname() .. "%" .. vim.fn.fnamemodify(tostring(request.selection), ":p:gs?/?%?"))
      vim.api.nvim_buf_set_name(request.bufnr, fake_path)
      local function _5_(...)
        return vim.api.nvim_command("filetype detect", ...)
      end
      return vim.api.nvim_buf_call(request.bufnr, _5_)
    end
  end
  snap.sync(_4_)
  preview = nil
  return nil
end
return _1_