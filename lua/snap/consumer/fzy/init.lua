local _2afile_2a = "fnl/snap/consumer/fzy/init.fnl"
local filter = require("snap.consumer.fzy.filter")
local score = require("snap.consumer.fzy.score")
local cache = require("snap.consumer.cache")
local function _1_(producer)
  return score(filter(cache(producer)))
end
return _1_