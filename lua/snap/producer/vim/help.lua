local _2afile_2a = "fnl/snap/producer/vim/help.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local read_file = snap.get("preview.read-file")
local function _1_()
  local tags_set = {}
  local tag_files
  local function _2_(...)
    return vim.fn.globpath(vim.o.runtimepath, "doc/tags", 1, 1, ...)
  end
  tag_files = snap.sync(_2_)
  for _, tag_file in ipairs(tag_files) do
    local tags = {}
    local contents = read_file(tag_file)
    for _0, line in ipairs(contents) do
      if not line:match("^!_TAG_") then
        local _local_0_ = vim.split(line, string.char(9), true)
        local name = _local_0_[1]
        if not tags_set[name] then
          tags_set[name] = true
          table.insert(tags, name)
        end
      end
    end
    coroutine.yield(tags)
  end
  return nil
end
return _1_