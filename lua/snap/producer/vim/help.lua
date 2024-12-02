local _2afile_2a = "fnl/snap/producer/vim/help.fnl"
local snap = require("snap")
local tbl = snap.get("common.tbl")
local read_file = snap.get("preview.common.read-file")
local function _1_()
  local tags_set = {}
  local tag_files
  local function _3_()
    local _2_ = vim.o.runtimepath
    local function _4_(...)
      return vim.fn.globpath(_2_, "doc/tags", 1, 1, ...)
    end
    return _4_
  end
  tag_files = snap.sync(_3_())
  for _, tag_file in ipairs(tag_files) do
    local tags = {}
    local contents = read_file(tag_file)
    for _0, line in ipairs(contents) do
      if not line:match("^!_TAG_") then
        local _local_5_ = vim.split(line, string.char(9), true)
        local name = _local_5_[1]
        if not tags_set[name] then
          tags_set[name] = true
          table.insert(tags, name)
        else
        end
      else
      end
    end
    coroutine.yield(tags)
  end
  return nil
end
return _1_
