local _2afile_2a = "fnl/snap/producer/tmux/session.fnl"
local snap = require("snap")
local io = require("snap.common.io")
local string = require("snap.common.string")
local function _1_(request)
  local cwd = snap.sync(vim.fn.getcwd)
  for data, err, cancel in io.spawn("tmux", {"list-sessions", "-F", "#S"}, cwd) do
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
return _1_