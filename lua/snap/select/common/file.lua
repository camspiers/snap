local _2afile_2a = "fnl/snap/select/common/file.fnl"
local function _1_(get_data)
  local function _2_(selection, winnr, type)
    local winnr0 = winnr
    local _let_3_ = get_data(selection)
    local filename = _let_3_["filename"]
    local line = _let_3_["line"]
    local column = _let_3_["column"]
    local path = vim.fn.fnamemodify(filename, ":p")
    local buffer = vim.fn.bufnr(path, true)
    vim.api.nvim_buf_set_option(buffer, "buflisted", true)
    do
      local _4_ = type
      if (_4_ == nil) then
        if (winnr0 ~= false) then
          vim.api.nvim_win_set_buf(winnr0, buffer)
        else
        end
      elseif (_4_ == "vsplit") then
        vim.api.nvim_command("vsplit")
        vim.api.nvim_win_set_buf(0, buffer)
        winnr0 = vim.api.nvim_get_current_win()
      elseif (_4_ == "split") then
        vim.api.nvim_command("split")
        vim.api.nvim_win_set_buf(0, buffer)
        winnr0 = vim.api.nvim_get_current_win()
      elseif (_4_ == "tab") then
        vim.api.nvim_command("tabnew")
        vim.api.nvim_win_set_buf(0, buffer)
        winnr0 = vim.api.nvim_get_current_win()
      else
      end
    end
    if (line ~= nil) then
      local function _7_()
        if (column == nil) then
          return 0
        else
          return column
        end
      end
      return vim.api.nvim_win_set_cursor(winnr0, {line, _7_()})
    else
      return nil
    end
  end
  return _2_
end
return _1_