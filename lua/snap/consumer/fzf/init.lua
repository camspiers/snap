local _2afile_2a = "fnl/snap/consumer/fzf/init.fnl"
local snap = require("snap")
local io = snap.get("common.io")
local cache = snap.get("consumer.cache")
local positions = snap.get("consumer.positions")
local tbl = snap.get("common.tbl")
local function _1_(producer)
  local cached_producer = cache(producer)
  local function _2_(request)
    local files = {}
    local files_string = nil
    for data in snap.consume(cached_producer, request) do
      tbl.accumulate(files, data)
      snap.continue()
    end
    if (request.filter == "") then
      return coroutine.yield(files)
    else
      local needsdata = true
      local cwd = snap.sync(vim.fn.getcwd)
      local stdout = vim.loop.new_pipe(false)
      for data, err, cancel in io.spawn("fzf", {"-f", request.filter}, cwd, stdout) do
        if needsdata then
          if (files_string == nil) then
            files_string = table.concat(files, "\n")
          end
          stdout:write(files_string)
          stdout:shutdown()
          needsdata = false
        end
        if request.canceled() then
          cancel()
          coroutine.yield(nil)
        elseif (err ~= "") then
          coroutine.yield(nil)
        elseif (data == "") then
          snap.continue()
        else
          coroutine.yield(vim.split(data:sub(1, -2), "\n", true))
        end
      end
      return nil
    end
  end
  return positions(_2_)
end
return _1_