local _2afile_2a = "fnl/snap/producer/ripgrep/file.fnl"
local snap = require("snap")
local general = snap.get("producer.ripgrep.general")
local function _1_(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return general(request, {args = {"--files"}, cwd = cwd})
end
return _1_