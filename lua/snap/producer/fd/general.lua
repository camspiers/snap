local _2afile_2a = "fnl/snap/producer/fd/general.fnl"
local io = require("snap.io")
local function _1_(args, cwd, request)
  for data, err, kill in io.spawn("fd", args, cwd) do
    if request.canceled() then
      kill()
      coroutine.yield(nil)
    elseif (err ~= "") then
      coroutine.yield(nil)
    elseif (data == "") then
      coroutine.yield({})
    else
      coroutine.yield(vim.split(data, "\n", true))
    end
  end
  return nil
end
return _1_