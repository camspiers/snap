local _2afile_2a = "fnl/snap/consumer/fzy/init.fnl"
local all = require("snap.consumer.fzy.all")
local cache = require("snap.consumer.cache")
local function _1_(producer)
  return all(cache(producer))
end
return _1_