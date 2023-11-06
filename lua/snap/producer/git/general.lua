local _2afile_2a = "fnl/snap/producer/git/general.fnl"
local io = require("snap.common.io")
local string = require("snap.common.string")
local function _3_(request, _1_)
  local _arg_2_ = _1_
  local args = _arg_2_["args"]
  local cwd = _arg_2_["cwd"]
  for data, err, cancel in io.spawn("git", args, cwd) do
    if request.canceled() then
      cancel()
      coroutine.yield(nil)
    elseif (err ~= "") then
      coroutine.yield(nil)
    elseif (data == "") then
      coroutine.yield({})
    else
      coroutine.yield(string.split(data))
    end
  end
  return nil
end
return _3_