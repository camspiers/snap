local _2afile_2a = "fnl/snap/producer/ripgrep/vimgrep.fnl"
local snap = require("snap")
local general = require("snap.producer.ripgrep.general")
local function _1_(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return general({"--vimgrep", "--hidden", request.filter}, cwd, request)
end
return _1_