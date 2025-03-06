local _2afile_2a = "fnl/snap/preview/help.fnl"
local snap = require("snap")
local read_file = snap.get("preview.common.read-file")
local loading = snap.get("loading")
local syntax = snap.get("preview.common.syntax")
local function _1_(request)
  local function _2_()
    if not request.canceled() then
      vim.api.nvim_buf_set_option(request.bufnr, "buftype", "help")
      local function _3_()
        vim.api.nvim_command(string.format("noautocmd help %s", tostring(request.selection)))
        return vim.api.nvim_buf_set_option(request.bufnr, "syntax", "help")
      end
      return vim.api.nvim_buf_call(request.bufnr, _3_)
    else
      return nil
    end
  end
  return snap.sync(_2_)
end
return _1_