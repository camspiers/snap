local _2afile_2a = "fnl/snap/consumer/fzy/init.fnl"
local filter = require("snap.consumer.fzy.filter")
local score = require("snap.consumer.fzy.score")
local positions = require("snap.consumer.fzy.positions")
local cache = require("snap.consumer.cache")
local function _1_(producer)
  return positions(score(filter(cache(producer))))
end
return _1_