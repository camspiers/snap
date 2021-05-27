local _2afile_2a = "fnl/snap/preview/file.fnl"
local snap = require("snap")
local function _1_(request)
  local path
  local function _2_(...)
    return vim.fn.fnamemodify(request.selection, ":p", ...)
  end
  path = snap.sync(_2_)
  local handle = io.popen(string.format("file -n -b --mime-encoding %s", path))
  local encoding = string.gsub(handle:read("*a"), "^%s*(.-)%s*$", "%1")
  if (encoding == "binary") then
    return {"Binary file"}
  else
    local fd = assert(vim.loop.fs_open(path, "r", 438))
    local stat = assert(vim.loop.fs_fstat(fd))
    local data = assert(vim.loop.fs_read(fd, stat.size, 0))
    assert(vim.loop.fs_close(fd))
    return vim.split(data, "\n", true)
  end
end
return _1_