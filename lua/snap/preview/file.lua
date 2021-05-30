local _2afile_2a = "fnl/snap/preview/file.fnl"
local snap = require("snap")
local max_size = 100000
local function _1_(request)
  local path
  local function _2_(...)
    return vim.fn.fnamemodify(request.selection, ":p", ...)
  end
  path = snap.sync(_2_)
  local handle = io.popen(string.format("file -n -b --mime-encoding %s", path))
  local encoding = string.gsub(handle:read("*a"), "^%s*(.-)%s*$", "%1")
  handle:close()
  snap.continue()
  local has_whole_file = false
  local preview
  if (encoding == "binary") then
    preview = {"Binary file"}
  else
    local fd = assert(vim.loop.fs_open(path, "r", 438))
    local stat = assert(vim.loop.fs_fstat(fd))
    local data = assert(vim.loop.fs_read(fd, math.min(stat.size, max_size), 0))
    assert(vim.loop.fs_close(fd))
    has_whole_file = (max_size >= stat.size)
    preview = vim.split(data, "\n", true)
  end
  snap.continue()
  local function _4_()
    if not request.canceled() then
      vim.api.nvim_win_set_option(request.winnr, "cursorline", false)
      vim.api.nvim_win_set_option(request.winnr, "cursorcolumn", false)
      vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, preview)
      if has_whole_file then
        local fake_path = (vim.fn.tempname() .. "%" .. vim.fn.fnamemodify(request.selection, ":p:gs?/?%?"))
        vim.api.nvim_buf_set_name(request.bufnr, fake_path)
        local function _5_(...)
          return vim.api.nvim_command("filetype detect", ...)
        end
        return vim.api.nvim_buf_call(request.bufnr, _5_)
      end
    end
  end
  return snap.sync(_4_)
end
return _1_