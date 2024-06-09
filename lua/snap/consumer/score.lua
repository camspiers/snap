local _2afile_2a = "fnl/snap/consumer/score.fnl"
local snap = require("snap")
local function _1_(producer)
  local function _2_(request)
    for data in snap.consume(producer, request) do
      local _3_ = type(data)
      if (_3_ == "table") then
        if (#data == 0) then
          snap.continue()
        else
          local function _4_(_241)
            return snap.with_meta(_241, "score", (0 - #tostring(_241)))
          end
          coroutine.yield(vim.tbl_map(_4_, data))
        end
      elseif (_3_ == "nil") then
        coroutine.yield(nil)
      else
      end
    end
    return nil
  end
  return _2_
end
return _1_