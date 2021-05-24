local _2afile_2a = "fnl/snap/io.fnl"
local _0_0
do
  local name_0_ = "snap.io"
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
  module_0_["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {require("snap")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {require = {snap = "snap"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local snap = _local_0_[1]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "snap.io"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local spawn
do
  local v_0_
  do
    local v_0_0
    local function spawn0(cmd, args, cwd)
      local stdinbuffer = ""
      local stderrbuffer = ""
      local stdout = vim.loop.new_pipe(false)
      local stderr = vim.loop.new_pipe(false)
      local handle
      local function _2_(code, signal)
        stdout:read_stop()
        stderr:read_stop()
        stdout:close()
        stderr:close()
        return handle:close()
      end
      handle = vim.loop.spawn(cmd, {args = args, cwd = cwd, stdio = {nil, stdout, stderr}}, _2_)
      local function _3_(err, data)
        assert(not err)
        if data then
          stdinbuffer = data
          return nil
        end
      end
      stdout:read_start(_3_)
      local function _4_(err, data)
        assert(not err)
        if data then
          stderrbuffer = data
          return nil
        end
      end
      stderr:read_start(_4_)
      local function kill()
        return handle:kill(vim.loop.constants.SIGTERM)
      end
      local function iterator()
        if (handle and handle:is_active()) then
          local stdin = stdinbuffer
          local stderr0 = stderrbuffer
          stdinbuffer = ""
          stderrbuffer = ""
          return stdin, stderr0, kill
        else
          return nil
        end
      end
      return iterator
    end
    v_0_0 = spawn0
    _0_0["spawn"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["spawn"] = v_0_
  spawn = v_0_
end
return nil