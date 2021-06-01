local _2afile_2a = "fnl/snap/consumer/chunk.fnl"
local function chunk(size, tbl)
  local index = 1
  local tbl_size = #tbl
  local function _1_()
    if (index == tbl_size) then
      return nil
    end
    local chunk0 = {}
    while ((index <= tbl_size) and (#chunk0 < size)) do
      table.insert(chunk0, tbl[index])
      index = (index + 1)
    end
    return chunk0
  end
  return _1_
end
local snap = require("snap")
local function _1_(chunk_size, producer)
  local function _2_(request)
    for results in snap.consume(producer, request) do
      if ((type(results) == "table") and (#results > 0)) then
        for part in chunk(chunk_size, results) do
          coroutine.yield(part)
        end
      else
        coroutine.yield(results)
      end
    end
    return nil
  end
  return _2_
end
return _1_