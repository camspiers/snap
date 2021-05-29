local _2afile_2a = "fnl/snap/producer/fd/file.fnl"
local snap = require("snap")
local general = snap.get("producer.fd.general")
local function _1_(request)
  local cwd = snap.sync(vim.fn.getcwd)
  return general(request, {args = {"-H", "-I"}, cwd = cwd})
end
return _1_