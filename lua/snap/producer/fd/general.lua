local _2afile_2a = "fnl/snap/producer/fd/general.fnl"
local io = require("snap.common.io")
local function _3_(request, _1_)
  local _arg_2_ = _1_
  local args = _arg_2_["args"]
  local cwd = _arg_2_["cwd"]
  for data, err, kill in io.spawn("fd", args, cwd) do
    if request.canceled() then
      kill()
      coroutine.yield(nil)
    elseif (err ~= "") then
      coroutine.yield(nil)
    elseif (data == "") then
      coroutine.yield({})
    else
      coroutine.yield(vim.split(data:sub(1, -2), "\n", true))
    end
  end
  return nil
end
return _3_