local _2afile_2a = "fnl/snap/consumer/fzy/all.fnl"
local snap = require("snap")
local fzy = require("fzy")
local function _1_(producer)
  local function filter(filter0, results)
    if (filter0 == "") then
      return results
    else
      local processed = {}
      for _, _2_ in ipairs(fzy.filter(filter0, results)) do
        local _each_3_ = _2_
        local index = _each_3_[1]
        local positions = _each_3_[2]
        local score = _each_3_[3]
        table.insert(processed, snap.with_metas(results[index], {positions = positions, score = score}))
      end
      return processed
    end
  end
  local function _5_(request)
    for results in snap.consume(producer, request) do
      local _6_ = type(results)
      if (_6_ == "table") then
        coroutine.yield(filter(request.filter, results))
      elseif (_6_ == "nil") then
        coroutine.yield(nil)
      else
      end
    end
    return nil
  end
  return _5_
end
return _1_