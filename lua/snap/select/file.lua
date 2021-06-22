local _2afile_2a = "fnl/snap/select/file.fnl"
local _0_
do
  local name_0_ = "snap.select.file"
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
local _2amodule_name_2a = "snap.select.file"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local select
do
  local v_0_
  do
    local v_0_0
    local function select0(selection, winnr, type)
      local path = vim.fn.fnamemodify(tostring(selection), ":p")
      local buffer = vim.fn.bufnr(path, true)
      vim.api.nvim_buf_set_option(buffer, "buflisted", true)
      local _3_ = type
      if (_3_ == nil) then
        if (winnr ~= false) then
          return vim.api.nvim_win_set_buf(winnr, buffer)
        end
      elseif (_3_ == "vsplit") then
        vim.api.nvim_command("vsplit")
        return vim.api.nvim_win_set_buf(0, buffer)
      elseif (_3_ == "split") then
        vim.api.nvim_command("split")
        return vim.api.nvim_win_set_buf(0, buffer)
      elseif (_3_ == "tab") then
        vim.api.nvim_command("tabnew")
        return vim.api.nvim_win_set_buf(0, buffer)
      end
    end
    v_0_0 = select0
    _0_["select"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["select"] = v_0_
  select = v_0_
end
local multiselect
do
  local v_0_
  do
    local v_0_0
    local function multiselect0(selections, winnr)
      for index, selection in ipairs(selections) do
        local function _3_()
          if (#selections == index) then
            return winnr
          else
            return false
          end
        end
        select(selection, _3_())
      end
      return nil
    end
    v_0_0 = multiselect0
    _0_["multiselect"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["multiselect"] = v_0_
  multiselect = v_0_
end
return nil