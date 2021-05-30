local _2afile_2a = "fnl/snap/producer/luv/general.fnl"
local snap = require("snap")
local function _1_(types, cwd)
  local dirs = {cwd}
  local relative_dir
  local function _2_(...)
    return vim.fn.fnamemodify(cwd, ":.", ...)
  end
  relative_dir = snap.sync(_2_)
  while (#dirs > 0) do
    local dir = table.remove(dirs)
    local handle = vim.loop.fs_scandir(dir)
    local results = {}
    while handle do
      local name, t = vim.loop.fs_scandir_next(handle)
      if name then
        local path = (dir .. "/" .. name)
        local relative_path
        local function _3_(...)
          return vim.fn.fnamemodify(path, ":.", ...)
        end
        relative_path = snap.sync(_3_)
        if types[t] then
          table.insert(results, relative_path)
        end
        if (t == "directory") then
          table.insert(dirs, path)
        end
      else
        break
      end
    end
    coroutine.yield(results)
  end
  return nil
end
return _1_