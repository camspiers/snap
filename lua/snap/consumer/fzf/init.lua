local _2afile_2a = "fnl/snap/consumer/fzf/init.fnl"
local snap = require("snap")
local io = snap.get("common.io")
local cache = snap.get("consumer.cache")
local positions = snap.get("consumer.positions")
local tbl = snap.get("common.tbl")
local function _1_(producer)
  local cached_producer = cache(producer)
  local function _2_(request)
    local results = {}
    local results_string = nil
    for data in snap.consume(cached_producer, request) do
      tbl.accumulate(results, data)
      snap.continue()
    end
    if (request.filter == "") then
      return coroutine.yield(results)
    else
      local needsdata = true
      local cwd = snap.sync(vim.fn.getcwd)
      local stdout = vim.loop.new_pipe(false)
      for data, err, cancel in io.spawn("fzf", {"-f", request.filter}, cwd, stdout) do
        if needsdata then
          if (results_string == nil) then
            local plain_results
            local function _3_(_241)
              return tostring(_241)
            end
            plain_results = vim.tbl_map(_3_, results)
            results_string = table.concat(plain_results, "\n")
          end
          stdout:write(results_string)
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
          local results_indexed = {}
          for _, result in ipairs(results) do
            results_indexed[tostring(result)] = result
          end
          local filtered_results = vim.split(data:sub(1, -2), "\n", true)
          local function _4_(_241)
            return results_indexed[_241]
          end
          coroutine.yield(vim.tbl_map(_4_, filtered_results))
        end
      end
      return nil
    end
  end
  return positions(_2_)
end
return _1_