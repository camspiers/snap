local _2afile_2a = "fnl/snap/producer/luv/file.fnl"
local snap = require("snap")
local general = snap.get("producer.luv.general")
local function _1_(request)
  return general({file = true}, snap.sync(vim.fn.getcwd))
end
return _1_