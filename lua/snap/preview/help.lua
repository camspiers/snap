local _2afile_2a = "fnl/snap/preview/help.fnl"
local snap = require("snap")
local read_file = snap.get("preview.read-file")
local loading = snap.get("loading")
local syntax = snap.get("preview.syntax")
local function _1_(request)
  local function _2_()
    if not request.canceled() then
      vim.api.nvim_buf_set_option(request.bufnr, "buftype", "help")
      local function _3_()
        return vim.api.nvim_command(string.format("help %s", tostring(request.selection)))
      end
      return vim.api.nvim_buf_call(request.bufnr, _3_)
    end
  end
  return snap.sync(_2_)
end
return _1_