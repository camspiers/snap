local _2afile_2a = "fnl/snap/select/vimgrep.fnl"
local _0_
do
  local name_0_ = "snap.select.vimgrep"
  local module_0_
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  do end (module_0_)["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  do end (package.loaded)[name_0_] = module_0_
  _0_ = module_0_
end
local autoload
local function _1_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _1_
local function _2_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _2_()
    return {}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local _2amodule_2a = _0_
local _2amodule_name_2a = "snap.select.vimgrep"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local parse = require("snap.common.vimgrep.parse")
local multiselect
do
  local v_0_
  do
    local v_0_0
    local function multiselect0(selections, winnr)
      vim.fn.setqflist(vim.tbl_map(parse, selections))
      vim.api.nvim_command("copen")
      return vim.api.nvim_command("cfirst")
    end
    v_0_0 = multiselect0
    _0_["multiselect"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["multiselect"] = v_0_
  multiselect = v_0_
end
local select
do
  local v_0_
  do
    local v_0_0
    local function select0(selection, winnr, type)
      local winnr0 = winnr
      local _let_0_ = parse(selection)
      local col = _let_0_["col"]
      local filename = _let_0_["filename"]
      local lnum = _let_0_["lnum"]
      local path = vim.fn.fnamemodify(filename, ":p")
      local buffer = vim.fn.bufnr(path, true)
      vim.api.nvim_buf_set_option(buffer, "buflisted", true)
      do
        local _3_ = type
        if (_3_ == nil) then
          if (winnr0 ~= false) then
            vim.api.nvim_win_set_buf(winnr0, buffer)
          end
        elseif (_3_ == "vsplit") then
          vim.api.nvim_command("vsplit")
          vim.api.nvim_win_set_buf(0, buffer)
          winnr0 = vim.api.nvim_get_current_win()
        elseif (_3_ == "split") then
          vim.api.nvim_command("split")
          vim.api.nvim_win_set_buf(0, buffer)
          winnr0 = vim.api.nvim_get_current_win()
        elseif (_3_ == "tab") then
          vim.api.nvim_command("tabnew")
          vim.api.nvim_win_set_buf(0, buffer)
          winnr0 = vim.api.nvim_get_current_win()
        end
      end
      return vim.api.nvim_win_set_cursor(winnr0, {lnum, col})
    end
    v_0_0 = select0
    _0_["select"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["select"] = v_0_
  select = v_0_
end
return nil