local _2afile_2a = "fnl/snap/config/init.fnl"
local _0_
do
  local name_0_ = "snap.config"
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
local _2amodule_name_2a = "snap.config"
do local _ = ({nil, _0_, nil, {{nil}, nil, nil, nil}})[2] end
local function format_prompt(suffix, prompt)
  return string.format("%s%s", prompt, (suffix or ">"))
end
local function with(fnc, defaults)
  local function _3_(config)
    return fnc(tbl.merge(defaults, config))
  end
  return _3_
end
local function file_producer_by_kind(config, kind)
  local producer
  do
    local _3_ = kind
    if (_3_ == "ripgrep.file") then
      producer = snap.get("producer.ripgrep.file")
    elseif (_3_ == "fd.file") then
      producer = snap.get("producer.fd.file")
    elseif (_3_ == "vim.oldfile") then
      producer = snap.get("producer.vim.oldfile")
    elseif (_3_ == "vim.buffer") then
      producer = snap.get("producer.vim.buffer")
    elseif (_3_ == "git.file") then
      producer = snap.get("producer.git.file")
    else
      local function _4_()
        local p = _3_
        return (type(p) == "function")
      end
      if ((nil ~= _3_) and _4_()) then
        local p = _3_
        producer = p
      else
        local _ = _3_
        producer = assert(false, "file.producer is invalid")
      end
    end
  end
  if ((kind == "ripgrep.file") or (kind == "fd.file")) then
    if config.args then
      producer = producer.args(config.args)
    elseif config.hidden then
      producer = producer.hidden
    end
  end
  return producer
end
local function file_prompt_by_kind(kind)
  local _3_ = kind
  if (_3_ == "ripgrep.file") then
    return "Rg Files"
  elseif (_3_ == "fd.file") then
    return "Fd Files"
  elseif (_3_ == "vim.oldfile") then
    return "Old Files"
  elseif (_3_ == "vim.buffer") then
    return "Buffers"
  elseif (_3_ == "git.file") then
    return "Git Files"
  else
    local _ = _3_
    return "Custom Files"
  end
end
local file
do
  local v_0_
  do
    local v_0_0
    local function _3_(self_0_, ...)
      local function _4_(config)
        assert((type(config) == "table"))
        if config.prompt then
          assert((type(config.prompt) == "string"), "file.prompt must be a string")
        end
        if config.suffix then
          assert((type(config.suffix) == "string"), "file.suffix must be a string")
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
        if config.try then
          assert((type(config.try) == "table"), "file.try must be a table")
        end
        if config.combine then
          assert((type(config.combine) == "table"), "file.combine must be a table")
        end
        assert((config.producer or config.try or config.combine), "one of file.producer, file.try or file.combine must be set")
        assert(not (config.producer and config.try), "file.try and file.producer can not be used together")
        assert(not (config.producer and config.combine), "file.combine and file.producer can not be used together")
        assert(not (config.try and config.combine), "file.try and file.combine can not be used together")
        assert(not (config.hidden and config.args), "file.args and file.hidden can not be used together")
        local by_kind
        local function _12_(...)
          return file_producer_by_kind(config, ...)
        end
        by_kind = _12_
        local consumer_kind = (config.consumer or "fzf")
        local producer
        if config.try then
          producer = snap.get("consumer.try")(unpack(vim.tbl_map(by_kind, config.try)))
        elseif config.combine then
          producer = snap.get("consumer.combine")(unpack(vim.tbl_map(by_kind, config.combine)))
        else
          producer = by_kind(config.producer)
        end
        local consumer
        do
          local _14_ = consumer_kind
          if (_14_ == "fzf") then
            consumer = snap.get("consumer.fzf")
          elseif (_14_ == "fzy") then
            consumer = snap.get("consumer.fzy")
          else
            local function _15_()
              local c = _14_
              return (type(c) == "function")
            end
            if ((nil ~= _14_) and _15_()) then
              local c = _14_
              consumer = c
            else
              local _ = _14_
              consumer = assert(false, "file.consumer is invalid")
            end
          end
        end
        local add_prompt_suffix
        local function _15_(...)
          return format_prompt(config.suffix, ...)
        end
        add_prompt_suffix = _15_
        local prompt
        local function _16_()
          if config.prompt then
            return config.prompt
          elseif config.producer then
            return file_prompt_by_kind(config.producer)
          elseif config.try then
            return table.concat(vim.tbl_map(file_prompt_by_kind, config.try), " or ")
          elseif config.combine then
            return table.concat(vim.tbl_map(file_prompt_by_kind, config.combine), " + ")
          end
        end
        prompt = add_prompt_suffix(_16_())
        local select_file = snap.get("select.file")
        local function _17_()
          local reverse = (config.reverse or false)
          local layout = (config.layout or nil)
          local producer0 = consumer(producer)
          local select = select_file.select
          local multiselect = select_file.multiselect
          local views = {snap.get("preview.file")}
          return snap.run({layout = layout, multiselect = multiselect, producer = producer0, prompt = prompt, reverse = reverse, select = select, views = views})
        end
        return _17_
      end
      return _4_(...)
    end
    v_0_0 = setmetatable({with = with}, {__call = _3_})
    do end (_0_)["file"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["file"] = v_0_
  file = v_0_
end
local function vimgrep_prompt_by_kind(kind)
  local _3_ = kind
  if (_3_ == "ripgrep.vimgrep") then
    return "Rg Vimgrep"
  else
    local _ = _3_
    return "Custom Vimgrep"
  end
end
local vimgrep
do
  local v_0_
  do
    local v_0_0
    local function _3_(self_0_, ...)
      local function _4_(config)
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
        if config.suffix then
          assert((type(config.suffix) == "string"), "vimgrep.suffix must be a string")
        end
        local producer_kind = (config.producer or "ripgrep.vimgrep")
        local producer
        do
          local _11_ = producer_kind
          if (_11_ == "ripgrep.vimgrep") then
            producer = snap.get("producer.ripgrep.vimgrep")
          else
            local function _12_()
              local p = _11_
              return (type(p) == "function")
            end
            if ((nil ~= _11_) and _12_()) then
              local p = _11_
              producer = p
            else
              local _ = _11_
              producer = assert(false, "vimgrep.producer is invalid")
            end
          end
        end
        if (producer_kind == "ripgrep.vimgrep") then
          if config.args then
            producer = producer.args(config.args)
          elseif config.hidden then
            producer = producer.hidden
          end
        end
        local consumer
        if config.limit then
          local function _13_(...)
            return snap.get("consumer.limit")(config.limit, ...)
          end
          consumer = _13_
        else
          local function _13_(producer0)
            return producer0
          end
          consumer = _13_
        end
        local format_prompt0
        local function _14_(...)
          return format_prompt(config.suffix, ...)
        end
        format_prompt0 = _14_
        local prompt
        local function _15_()
          if config.prompt then
            return config.prompt
          elseif producer_kind then
            return vimgrep_prompt_by_kind(producer_kind)
          end
        end
        prompt = format_prompt0(_15_())
        local vimgrep_select = snap.get("select.vimgrep")
        local function _16_()
          local layout = (config.layout or nil)
          local producer0 = consumer(producer)
          local select = vimgrep_select.select
          local multiselect = vimgrep_select.multiselect
          local views = {snap.get("preview.vimgrep")}
          return snap.run({layout = layout, multiselect = multiselect, producer = producer0, prompt = prompt, select = select, views = views})
        end
        return _16_
      end
      return _4_(...)
    end
    v_0_0 = setmetatable({with = with}, {__call = _3_})
    do end (_0_)["vimgrep"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["vimgrep"] = v_0_
  vimgrep = v_0_
end
return nil