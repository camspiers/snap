local _2afile_2a = "fnl/snap/producer/ripgrep/general.fnl"
local snap = require("snap")
local io = require("snap.common.io")
local function _3_(request, _1_)
  local _arg_2_ = _1_
  local args = _arg_2_["args"]
  local cwd = _arg_2_["cwd"]
  local absolute = _arg_2_["absolute"]
  for data, err, cancel in io.spawn("rg", args, cwd) do
    if request.canceled() then
      cancel()
      coroutine.yield(nil)
    elseif (err ~= "") then
      coroutine.yield(nil)
    elseif (data == "") then
      snap.continue()
    else
      local results
      do
        local tbl_17_auto = {}
        local i_18_auto = #tbl_17_auto
        for _, str in ipairs(vim.split(data, "\n", true)) do
          local val_19_auto
          do
            local trimmed = vim.trim(str)
            if (trimmed ~= "") then
              val_19_auto = trimmed
            else
              val_19_auto = nil
            end
          end
          if (nil ~= val_19_auto) then
            i_18_auto = (i_18_auto + 1)
            do end (tbl_17_auto)[i_18_auto] = val_19_auto
          else
          end
        end
        results = tbl_17_auto
      end
      if absolute then
        local function _6_(_241)
          return string.format("%s/%s", cwd, _241)
        end
        results = vim.tbl_map(_6_, results)
      else
      end
      coroutine.yield(results)
    end
  end
  return nil
end
return _3_