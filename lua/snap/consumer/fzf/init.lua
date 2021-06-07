local _2afile_2a = "fnl/snap/consumer/fzf/init.fnl"
local snap = require("snap")
local io = snap.get("common.io")
local cache = snap.get("consumer.cache")
local tbl = snap.get("common.tbl")
local function _1_(producer)
  local cached_producer = cache(producer)
  local function _2_(request)
    local sent = false
    local files = {}
    for data in snap.consume(cached_producer, request) do
      tbl.accumulate(files, data)
      snap.continue()
    end
    if (request.filter == "") then
      return coroutine.yield(files)
    else
      local cwd = snap.sync(vim.fn.getcwd)
      local stdout = vim.loop.new_pipe(false)
      for data, err, cancel in io.spawn("fzf", {"-f", request.filter}, cwd, stdout) do
        if not sent then
          stdout:write(table.concat(files, "\n"))
          stdout:shutdown()
          sent = true
        end
        if request.canceled() then
          cancel()
          coroutine.yield(nil)
        elseif (err ~= "") then
          coroutine.yield(nil)
        elseif (data == "") then
          snap.continue()
        else
          coroutine.yield(vim.split(data, "\n", true))
        end
      end
      return nil
    end
  end
  return _2_
end
return _1_