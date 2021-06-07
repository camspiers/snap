local _2afile_2a = "fnl/snap/consumer/positions.fnl"
local snap = require("snap")
local function get_positions(result, filter)
  if (filter == "") then
    return {}
  else
    local positions = {}
    local filter0 = string.upper(filter)
    local result0 = string.upper(tostring(result))
    for c in filter0:gmatch(".") do
      local last_index = 1
      while true do
        local index = result0:find(c, last_index, true)
        if (index ~= nil) then
          last_index = (index + 1)
          table.insert(positions, index)
        else
          break
        end
      end
    end
    return positions
  end
end
local function _1_(producer)
  local function _2_(request)
    for data in snap.consume(producer, request) do
      local _3_ = type(data)
      if (_3_ == "table") then
        if (#data == 0) then
          snap.continue()
        else
          local function _4_(_241)
            return snap.with_meta(_241, "positions", get_positions(_241, request.filter))
          end
          coroutine.yield(vim.tbl_map(_4_, data))
        end
      elseif (_3_ == "nil") then
        coroutine.yield(nil)
      end
    end
    return nil
  end
  return _2_
end
return _1_