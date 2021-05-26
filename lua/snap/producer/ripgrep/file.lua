local _2afile_2a = "fnl/snap/producer/ripgrep/file.fnl"
local snap = require("snap")
local general = require("snap.producer.ripgrep.general")
local function _1_(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return general({"--files", "--no-ignore", "--hidden"}, cwd, request)
end
return _1_