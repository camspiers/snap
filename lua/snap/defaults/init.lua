local _2afile_2a = "fnl/snap/defaults/init.fnl"
local _0_
do
  local name_0_ = "snap.defaults"
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
    return {require("snap"), require("snap.common.tbl")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {["require-macros"] = {["snap.macros"] = true}, require = {snap = "snap", tbl = "snap.common.tbl"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local snap = _local_0_[1]
local tbl = _local_0_[2]
local _2amodule_2a = _0_
local _2amodule_name_2a = "snap.defaults"
do local _ = ({nil, _0_, nil, {{nil}, nil, nil, nil}})[2] end
local with
do
  local v_0_
  do
    local v_0_0
    local function with0(type, defaults)
      local function _3_(config)
        return type(tbl.merge(defaults, config))
      end
      return _3_
    end
    v_0_0 = with0
    _0_["with"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["with"] = v_0_
  with = v_0_
end
local file
do
  local v_0_
  do
    local v_0_0
    local function file0(config)
      assert((type(config) == "table"))
      if config.prompt then
        assert((type(config.prompt) == "string"), "file.prompt must be a string")
      end
      if config.layout then
        assert((type(config.layout) == "function"), "file.layout must be a function")
      end
      if config.args then
        assert((type(config.args) == "table"), "file.args must be a table")
      end
      if config.hidden then
        assert((type(config.hidden) == "boolean"), "file.hidden must be a boolean")
      end
      local producer_type = (config.producer or "ripgrep.file")
      local consumer_type = (config.consumer or "fzf")
      local producer
      do
        local _7_ = producer_type
        if (_7_ == "ripgrep.file") then
          producer = snap.get("producer.ripgrep.file")
        elseif (_7_ == "vim.oldfile") then
          producer = snap.get("producer.vim.oldfile")
        elseif (_7_ == "vim.buffer") then
          producer = snap.get("producer.vim.buffer")
        elseif (_7_ == "git.file") then
          producer = snap.get("producer.git.file")
        else
          local function _8_()
            local p = _7_
            return (type(p) == "function")
          end
          if ((nil ~= _7_) and _8_()) then
            local p = _7_
            producer = p
          else
            local _ = _7_
            producer = assert(false, "file.producer is invalid")
          end
        end
      end
      if (producer_type == "ripgrep.file") then
        if config.args then
          producer = producer.args(config.args)
        elseif config.hidden then
          producer = producer.hidden
        end
      end
      local consumer
      do
        local _9_ = consumer_type
        if (_9_ == "fzf") then
          consumer = snap.get("consumer.fzf")
        elseif (_9_ == "fzy") then
          consumer = snap.get("consumer.fzy")
        else
          local function _10_()
            local c = _9_
            return (type(c) == "function")
          end
          if ((nil ~= _9_) and _10_()) then
            local c = _9_
            consumer = c
          else
            local _ = _9_
            consumer = assert(false, "file.consumer is invalid")
          end
        end
      end
      local prompt
      local function _11_()
        local _10_ = producer_type
        if (_10_ == "ripgrep.file") then
          return "Files>"
        elseif (_10_ == "vim.oldfile") then
          return "Old Files>"
        elseif (_10_ == "vim.buffer") then
          return "Buffers>"
        elseif (_10_ == "git.file") then
          return "Git Files>"
        else
          local _ = _10_
          return "Files>"
        end
      end
      prompt = (config.prompt or _11_())
      local select = snap.get("select.file")
      local function _12_()
        return snap.run({layout = (config.layout or nil), multiselect = select.multiselect, producer = consumer(producer), prompt = prompt, reverse = (config.reverse or false), select = select.select, views = {snap.get("preview.file")}})
      end
      return _12_
    end
    v_0_0 = file0
    _0_["file"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["file"] = v_0_
  file = v_0_
end
local vimgrep
do
  local v_0_
  do
    local v_0_0
    local function vimgrep0(config)
      assert((type(config) == "table"))
      if config.prompt then
        assert((type(config.prompt) == "string"), "vimgrep.prompt must be a string")
      end
      if config.limit then
        assert((type(config.limit) == "number"), "vimgrep.limit must be a number")
      end
      if config.layout then
        assert((type(config.layout) == "function"), "vimgrep.layout must be a function")
      end
      if config.args then
        assert((type(config.args) == "table"), "vimgrep.args must be a table")
      end
      if config.hidden then
        assert((type(config.hidden) == "boolean"), "vimgrep.hidden must be a boolean")
      end
      local producer_type = (config.producer or "ripgrep.vimgrep")
      local producer
      do
        local _8_ = producer_type
        if (_8_ == "ripgrep.vimgrep") then
          producer = snap.get("producer.ripgrep.vimgrep")
        else
          local function _9_()
            local p = _8_
            return (type(p) == "function")
          end
          if ((nil ~= _8_) and _9_()) then
            local p = _8_
            producer = p
          else
            local _ = _8_
            producer = assert(false, "vimgrep.producer is invalid")
          end
        end
      end
      if (producer_type == "ripgrep.vimgrep") then
        if config.args then
          producer = producer.args(config.args)
        elseif config.hidden then
          producer = producer.hidden
        end
      end
      local consumer
      if config.limit then
        local function _10_(...)
          return snap.get("consumer.limit")(config.limit, ...)
        end
        consumer = _10_
      else
        local function _10_(producer0)
          return producer0
        end
        consumer = _10_
      end
      local select = snap.get("select.vimgrep")
      local function _11_()
        return snap.run({layout = (config.layout or nil), multiselect = select.multiselect, producer = consumer(producer), prompt = (config.prompt or "Grep>"), select = select.select, views = {snap.get("preview.vimgrep")}})
      end
      return _11_
    end
    v_0_0 = vimgrep0
    _0_["vimgrep"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["vimgrep"] = v_0_
  vimgrep = v_0_
end
return nil