local _2afile_2a = "fnl/snap/preview/common/syntax.fnl"
local snap_io = require("snap.common.io")
local function _1_(file_name, bufnr)
  local fake_path = (vim.fn.tempname() .. "/" .. file_name)
  pcall(vim.api.nvim_buf_set_name, bufnr, fake_path)
  local filetype = (vim.filetype.match({filename = file_name}) or "")
  if (filetype ~= "") then
    vim.api.nvim_set_option_value("filetype", filetype, {buf = bufnr})
    local lang = (vim.treesitter.language.get_lang(filetype) or filetype)
    local ts_ok_3f, _ = pcall(vim.treesitter.start, bufnr, lang)
    if not ts_ok_3f then
      return vim.api.nvim_set_option_value("syntax", filetype, {buf = bufnr})
    else
      return nil
    end
  else
    return nil
  end
end
return _1_