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
local default_min_width = (80 * 2)
local function preview_disabled(min_width)
  return (vim.api.nvim_get_option("columns") <= (min_width or default_min_width))
end
local function hide_views(config)
  local _3_ = type(config.preview)
  if (_3_ == "nil") then
    return preview_disabled(config.preview_min_width)
  elseif (_3_ == "boolean") then
    return ((config.preview == false) or preview_disabled(config.preview_min_width))
  elseif (_3_ == "function") then
    return not config.preview()
  end
end
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
local function current_word()
  return vim.fn.expand("<cword>")
end
local function current_selection()
  local register = vim.fn.getreg("\"")
  vim.api.nvim_exec("normal! y", false)
  local filter = vim.fn.trim(vim.fn.getreg("@"))
  vim.fn.setreg("\"", register)
  return filter
end
local function get_initial_filter(config)
  if (config.filter_with ~= nil) then
    local _3_ = config.filter_with
    if (_3_ == "cword") then
      return current_word()
    elseif (_3_ == "selection") then
      return current_selection()
    else
      local _ = _3_
      return assert(false, "config.filter_with must be a string cword, or selection")
    end
  elseif (config.filter ~= nil) then
    local _3_ = type(config.filter)
    if (_3_ == "function") then
      return config.filter()
    elseif (_3_ == "string") then
      return config.filter
    else
      local _ = _3_
      return assert(false, "config.filter must be a string or function")
    end
  else
    return nil
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
        if config.reverse then
          assert((type(config.reverse) == "boolean"), "file.reverse must be a boolean")
        end
        if config.preview_min_width then
          assert((type(config.preview_min_width) == "number"), "file.preview-min-with must be a number")
        end
        if config.mappings then
          assert((type(config.mappings) == "table"), "file.mappings must be a table")
        end
        if config.preview then
          assert(vim.tbl_contains({"function", "boolean"}, type(config.preview)), "file.preview must be a boolean or a function")
        end
        assert((config.producer or config.try or config.combine), "one of file.producer, file.try or file.combine must be set")
        assert(not (config.producer and config.try), "file.try and file.producer can not be used together")
        assert(not (config.producer and config.combine), "file.combine and file.producer can not be used together")
        assert(not (config.try and config.combine), "file.try and file.combine can not be used together")
        assert(not (config.hidden and config.args), "file.args and file.hidden can not be used together")
        local by_kind
        local function _16_(...)
          return file_producer_by_kind(config, ...)
        end
        by_kind = _16_
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
          local _18_ = consumer_kind
          if (_18_ == "fzf") then
            consumer = snap.get("consumer.fzf")
          elseif (_18_ == "fzy") then
            consumer = snap.get("consumer.fzy")
          else
            local function _19_()
              local c = _18_
              return (type(c) == "function")
            end
            if ((nil ~= _18_) and _19_()) then
              local c = _18_
              consumer = c
            else
              local _ = _18_
              consumer = assert(false, "file.consumer is invalid")
            end
          end
        end
        local add_prompt_suffix
        local function _19_(...)
          return format_prompt(config.suffix, ...)
        end
        add_prompt_suffix = _19_
        local prompt
        local function _20_()
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
        prompt = add_prompt_suffix(_20_())
        local select_file = snap.get("select.file")
        local function _21_()
          local hide_views0
          local function _22_(...)
            return hide_views(config, ...)
          end
          hide_views0 = _22_
          local reverse = (config.reverse or false)
          local layout = (config.layout or nil)
          local mappings = (config.mappings or nil)
          local producer0 = consumer(producer)
          local select = select_file.select
          local multiselect = select_file.multiselect
          local initial_filter = get_initial_filter(config)
          local views = {snap.get("preview.file")}
          return snap.run({hide_views = hide_views0, initial_filter = initial_filter, layout = layout, mappings = mappings, multiselect = multiselect, producer = producer0, prompt = prompt, reverse = reverse, select = select, views = views})
        end
        return _21_
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
        if config.reverse then
          assert((type(config.reverse) == "boolean"), "vimgrep.reverse must be a boolean")
        end
        if config.preview then
          assert((type(config.preview) == "boolean"), "vimgrep.preview must be a boolean")
        end
        if config.mappings then
          assert((type(config.mappings) == "table"), "vimgrep.mappings must be a table")
        end
        local producer_kind = (config.producer or "ripgrep.vimgrep")
        local producer
        do
          local _14_ = producer_kind
          if (_14_ == "ripgrep.vimgrep") then
            producer = snap.get("producer.ripgrep.vimgrep")
          else
            local function _15_()
              local p = _14_
              return (type(p) == "function")
            end
            if ((nil ~= _14_) and _15_()) then
              local p = _14_
              producer = p
            else
              local _ = _14_
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
          local function _16_(...)
            return snap.get("consumer.limit")(config.limit, ...)
          end
          consumer = _16_
        else
          local function _16_(producer0)
            return producer0
          end
          consumer = _16_
        end
        local format_prompt0
        local function _17_(...)
          return format_prompt(config.suffix, ...)
        end
        format_prompt0 = _17_
        local prompt
        local function _18_()
          if config.prompt then
            return config.prompt
          elseif producer_kind then
            return vimgrep_prompt_by_kind(producer_kind)
          end
        end
        prompt = format_prompt0(_18_())
        local vimgrep_select = snap.get("select.vimgrep")
        local function _19_()
          local hide_views0
          local function _20_(...)
            return hide_views(config, ...)
          end
          hide_views0 = _20_
          local reverse = (config.reverse or false)
          local layout = (config.layout or nil)
          local mappings = (config.mappings or nil)
          local producer0 = consumer(producer)
          local select = vimgrep_select.select
          local multiselect = vimgrep_select.multiselect
          local initial_filter = get_initial_filter(config)
          local views = {snap.get("preview.vimgrep")}
          return snap.run({hide_views = hide_views0, initial_filter = initial_filter, layout = layout, mappings = mappings, multiselect = multiselect, producer = producer0, prompt = prompt, reverse = reverse, select = select, views = views})
        end
        return _19_
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