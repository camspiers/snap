local _2afile_2a = "fnl/snap/io.fnl"
local _0_
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
    return {require("snap")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {require = {snap = "snap"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local snap = _local_0_[1]
local _2amodule_2a = _0_
local _2amodule_name_2a = "snap.io"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
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
      local function _3_(code, signal)
        stdout:read_stop()
        stderr:read_stop()
        stdout:close()
        stderr:close()
        return handle:close()
      end
      handle = vim.loop.spawn(cmd, {args = args, cwd = cwd, stdio = {nil, stdout, stderr}}, _3_)
      local function _4_(err, data)
        assert(not err)
        if data then
          stdinbuffer = (stdinbuffer .. data)
          return nil
        end
      end
      stdout:read_start(_4_)
      local function _5_(err, data)
        assert(not err)
        if data then
          stderrbuffer = (stderrbuffer .. data)
          return nil
        end
      end
      stderr:read_start(_5_)
      local function kill()
        return handle:kill(vim.loop.constants.SIGTERM)
      end
      local function _6_()
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
      return _6_
    end
    v_0_0 = spawn0
    _0_["spawn"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["spawn"] = v_0_
  spawn = v_0_
end
local chunk_size = 1000
local read
do
  local v_0_
  do
    local v_0_0
    local function read0(path)
      local closed = false
      local canceled = false
      local databuffer = ""
      local fd = nil
      local stat = nil
      local current_offset = 0
      local function on_close(err)
        return assert(not err, err)
      end
      local function close()
        closed = true
        return vim.loop.fs_close(fd, on_close)
      end
      local function cancel()
        canceled = true
        return nil
      end
      local function on_read(err, data)
        assert(not err, err)
        databuffer = (databuffer .. data)
        current_offset = (current_offset + chunk_size)
        if not closed then
          if (canceled or (current_offset >= stat.size)) then
            return close()
          else
            return vim.loop.fs_read(fd, chunk_size, current_offset, on_read)
          end
        end
      end
      local function on_stat(err, s)
        assert(not err, err)
        stat = s
        return vim.loop.fs_read(fd, math.min(chunk_size, stat.size), current_offset, on_read)
      end
      local function on_open(err, f)
        assert(not err, err)
        fd = f
        return vim.loop.fs_fstat(fd, on_stat)
      end
      local handle = vim.loop.fs_open(path, "r", 438, on_open)
      while (not closed or (databuffer ~= "")) do
        if (databuffer ~= "") then
          local data = databuffer
          databuffer = ""
          coroutine.yield(cancel, data)
        else
          coroutine.yield(cancel)
        end
      end
      return nil
    end
    v_0_0 = read0
    _0_["read"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["read"] = v_0_
  read = v_0_
end
return nil