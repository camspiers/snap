local _2afile_2a = "fnl/snap/preview/syntax.fnl"
local snap_io = require("snap.common.io")
local function _1_(path, bufnr)
  local has_treesitter = pcall(require, "nvim-treesitter")
  local _, highlight = pcall(require, "nvim-treesitter.highlight")
  local _0, parsers = pcall(require, "nvim-treesitter.parsers")
  local fake_path = (vim.fn.tempname() .. "/" .. path)
  vim.api.nvim_buf_set_name(bufnr, fake_path)
  local function _2_()
    local eventignore = vim.api.nvim_get_option("eventignore")
    vim.api.nvim_set_option("eventignore", "FileType")
    vim.api.nvim_command("filetype detect")
    return vim.api.nvim_set_option("eventignore", eventignore)
  end
  vim.api.nvim_buf_call(bufnr, _2_)
  local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
  if (filetype ~= "") then
    if has_treesitter then
      local lang = parsers.ft_to_lang(filetype)
      if parsers.has_parser(lang) then
        return highlight.attach(bufnr, lang)
      else
        return vim.api.nvim_buf_set_option(bufnr, "syntax", filetype)
      end
    else
      return vim.api.nvim_buf_set_option(bufnr, "syntax", filetype)
    end
  else
    return nil
  end
end
return _1_