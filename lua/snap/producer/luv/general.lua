local _2afile_2a = "fnl/snap/producer/luv/general.fnl"
local function _1_(types, cwd)
  local dirs = {cwd}
  while (#dirs > 0) do
    local dir = table.remove(dirs)
    local handle = vim.loop.fs_scandir(dir)
    local results = {}
    while handle do
      local name, t = vim.loop.fs_scandir_next(handle)
      if name then
        local path = (dir .. "/" .. name)
        if types[t] then
          table.insert(results, path)
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