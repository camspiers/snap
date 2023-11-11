local _2afile_2a = "fnl/snap/common/register.fnl"
local _2amodule_name_2a = "snap.common.register"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local tbl = require("snap.common.tbl")
do end (_2amodule_locals_2a)["tbl"] = tbl
local commands = {}
local function buf_map(bufnr, modes, keys, fnc, opts)
  for _, key in ipairs(keys) do
    for _0, mode in ipairs(modes) do
      vim.keymap.set(mode, key, fnc, tbl.merge((opts or {nowait = true}), {buffer = bufnr}))
    end
  end
  return nil
end
_2amodule_2a["buf-map"] = buf_map
local function handle_string(tbl0)
  local _1_ = type(tbl0)
  if (_1_ == "table") then
    return tbl0
  elseif (_1_ == "string") then
    return {tbl0}
  else
    return nil
  end
end
local function map(modes, keys, fnc, opts)
  for _, key in ipairs(handle_string(keys)) do
    for _0, mode in ipairs(handle_string(modes)) do
      vim.keymap.set(mode, key, fnc, (opts or {}))
    end
  end
  return nil
end
_2amodule_2a["map"] = map
local function command(name, fnc)
  if (#commands == 0) then
    local function _3_(opts)
      local name0 = opts.fargs[1]
      local _5_
      do
        local t_4_ = commands
        if (nil ~= t_4_) then
          t_4_ = (t_4_)[name0]
        else
        end
        _5_ = t_4_
      end
      if _5_ then
        return commands[name0]()
      else
        return nil
      end
    end
    local function _8_()
      return vim.tbl_keys(commands)
    end
    vim.api.nvim_create_user_command("Snap", _3_, {nargs = 1, complete = _8_})
  else
  end
  commands[name] = fnc
  return nil
end
_2amodule_2a["command"] = command
return _2amodule_2a