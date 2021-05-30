local _2afile_2a = "fnl/snap/preview/vimgrep.fnl"
local snap = require("snap")
local select = snap.get("select.vimgrep")
local max_size = 100000
local function _1_(request)
  local selection = select.parse(request.selection)
  local path
  local function _2_(...)
    return vim.fn.fnamemodify(selection.filename, ":p", ...)
  end
  path = snap.sync(_2_)
  local handle = io.popen(string.format("file -n -b --mime-encoding %s", path))
  local encoding = string.gsub(handle:read("*a"), "^%s*(.-)%s*$", "%1")
  handle:close()
  local preview
  if (encoding == "binary") then
    preview = {"Binary file"}
  else
    local fd = assert(vim.loop.fs_open(path, "r", 438))
    local stat = assert(vim.loop.fs_fstat(fd))
    local data = assert(vim.loop.fs_read(fd, math.min(stat.size, max_size), 0))
    assert(vim.loop.fs_close(fd))
    preview = vim.split(data, "\n", true)
  end
  if not request.canceled() then
    local function _4_()
      vim.api.nvim_win_set_option(request.winnr, "cursorline", true)
      vim.api.nvim_win_set_option(request.winnr, "cursorcolumn", true)
      vim.api.nvim_buf_set_lines(request.bufnr, 0, -1, false, preview)
      local fake_path = (vim.fn.tempname() .. "%" .. vim.fn.fnamemodify(request.selection, ":p:gs?/?%?"))
      vim.api.nvim_buf_set_name(request.bufnr, fake_path)
      local function _5_(...)
        return vim.api.nvim_command("filetype detect", ...)
      end
      vim.api.nvim_buf_call(request.bufnr, _5_)
      if ((encoding ~= "binary") and (selection.lnum <= #preview)) then
        return vim.api.nvim_win_set_cursor(request.winnr, {selection.lnum, (selection.col - 1)})
      end
    end
    return snap.sync(_4_)
  end
end
return _1_