local _2afile_2a = "fnl/snap/producer/fd/file.fnl"
local snap = require("snap")
local general = require("snap.producer.fd.general")
local function _1_(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return general({"-H", "-I"}, cwd, request)
end
return _1_