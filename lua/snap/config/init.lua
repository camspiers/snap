local _2afile_2a = "fnl/snap/config/init.fnl"
local _2amodule_name_2a = "snap.config"
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
local snap, tbl, _ = require("snap"), require("snap.common.tbl"), nil
_2amodule_locals_2a["snap"] = snap
_2amodule_locals_2a["tbl"] = tbl
_2amodule_locals_2a["_"] = _
local default_min_width = (80 * 2)
local function preview_disabled(min_width)
  return (vim.api.nvim_get_option("columns") <= (min_width or default_min_width))
end
local function hide_views(config)
  local _1_ = type(config.preview)
  if (_1_ == "nil") then
    return preview_disabled(config.preview_min_width)
  elseif (_1_ == "boolean") then
    return ((config.preview == false) or preview_disabled(config.preview_min_width))
  elseif (_1_ == "function") then
    return not config.preview()
  else
    return nil
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
    local _4_ = kind
    if (_4_ == "ripgrep.file") then
      producer = snap.get("producer.ripgrep.file")
    elseif (_4_ == "fd.file") then
      producer = snap.get("producer.fd.file")
    elseif (_4_ == "vim.oldfile") then
      producer = snap.get("producer.vim.oldfile")
    elseif (_4_ == "vim.buffer") then
      producer = snap.get("producer.vim.buffer")
    elseif (_4_ == "git.file") then
      producer = snap.get("producer.git.file")
    else
      local function _5_()
        local p = _4_
        return (type(p) == "function")
      end
      if ((nil ~= _4_) and _5_()) then
        local p = _4_
        producer = p
      elseif true then
        local _0 = _4_
        producer = assert(false, "file.producer is invalid")
      else
        producer = nil
      end
    end
  end
  if (config.args and ((kind == "ripgrep.file") or (kind == "fd.file") or (kind == "git.file"))) then
    producer = producer.args(config.args)
  elseif (config.hidden and ((kind == "ripgrep.file") or (kind == "fd.file"))) then
    producer = producer.hidden
  else
  end
  return producer
end
local function file_prompt_by_kind(kind)
  local _8_ = kind
  if (_8_ == "ripgrep.file") then
    return "Rg Files"
  elseif (_8_ == "fd.file") then
    return "Fd Files"
  elseif (_8_ == "vim.oldfile") then
    return "Old Files"
  elseif (_8_ == "vim.buffer") then
    return "Buffers"
  elseif (_8_ == "git.file") then
    return "Git Files"
  elseif true then
    local _0 = _8_
    return "Custom Files"
  else
    return nil
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
    local _10_ = config.filter_with
    if (_10_ == "cword") then
      return current_word()
    elseif (_10_ == "selection") then
      return current_selection()
    elseif true then
      local _0 = _10_
      return assert(false, "config.filter_with must be a string cword, or selection")
    else
      return nil
    end
  elseif (config.filter ~= nil) then
    local _12_ = type(config.filter)
    if (_12_ == "function") then
      return config.filter()
    elseif (_12_ == "string") then
      return config.filter
    elseif true then
      local _0 = _12_
      return assert(false, "config.filter must be a string or function")
    else
      return nil
    end
  else
    return nil
  end
end
_2amodule_2a["get_initial_filter"] = get_initial_filter
local file
local function _15_(self_1_auto, ...)
  local function _16_(config)
    assert((type(config) == "table"))
    if config.prompt then
      assert((type(config.prompt) == "string"), "file.prompt must be a string")
    else
    end
    if config.suffix then
      assert((type(config.suffix) == "string"), "file.suffix must be a string")
    else
    end
    if config.layout then
      assert((type(config.layout) == "function"), "file.layout must be a function")
    else
    end
    if config.args then
      assert((type(config.args) == "table"), "file.args must be a table")
    else
    end
    if config.hidden then
      assert((type(config.hidden) == "boolean"), "file.hidden must be a boolean")
    else
    end
    if config.try then
      assert((type(config.try) == "table"), "file.try must be a table")
    else
    end
    if config.combine then
      assert((type(config.combine) == "table"), "file.combine must be a table")
    else
    end
    if config.reverse then
      assert((type(config.reverse) == "boolean"), "file.reverse must be a boolean")
    else
    end
    if config.preview_min_width then
      assert((type(config.preview_min_width) == "number"), "file.preview-min-with must be a number")
    else
    end
    if config.mappings then
      assert((type(config.mappings) == "table"), "file.mappings must be a table")
    else
    end
    if config.preview then
      assert(vim.tbl_contains({"function", "boolean"}, type(config.preview)), "file.preview must be a boolean or a function")
    else
    end
    assert((config.producer or config.try or config.combine), "one of file.producer, file.try or file.combine must be set")
    assert(not (config.producer and config.try), "file.try and file.producer can not be used together")
    assert(not (config.producer and config.combine), "file.combine and file.producer can not be used together")
    assert(not (config.try and config.combine), "file.try and file.combine can not be used together")
    assert(not (config.hidden and config.args), "file.args and file.hidden can not be used together")
    local by_kind
    local function _28_(...)
      return file_producer_by_kind(config, ...)
    end
    by_kind = _28_
    local consumer_kind
    if (config.consumer ~= nil) then
      consumer_kind = config.consumer
    elseif pcall(require, "fzy") then
      consumer_kind = "fzy"
    else
      consumer_kind = "fzf"
    end
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
      local _31_ = consumer_kind
      if (_31_ == "fzf") then
        consumer = snap.get("consumer.fzf")
      elseif (_31_ == "fzy") then
        consumer = snap.get("consumer.fzy")
      else
        local function _32_()
          local c = _31_
          return (type(c) == "function")
        end
        if ((nil ~= _31_) and _32_()) then
          local c = _31_
          consumer = c
        elseif true then
          local _0 = _31_
          consumer = assert(false, "file.consumer is invalid")
        else
          consumer = nil
        end
      end
    end
    local add_prompt_suffix
    do
      local _34_ = config.suffix
      local function _35_(...)
        return format_prompt(_34_, ...)
      end
      add_prompt_suffix = _35_
    end
    local prompt
    local function _36_()
      if config.prompt then
        return config.prompt
      elseif config.producer then
        return file_prompt_by_kind(config.producer)
      elseif config.try then
        return table.concat(vim.tbl_map(file_prompt_by_kind, config.try), " or ")
      elseif config.combine then
        return table.concat(vim.tbl_map(file_prompt_by_kind, config.combine), " + ")
      else
        return nil
      end
    end
    prompt = add_prompt_suffix(_36_())
    local select_file = snap.get("select.file")
    local function _37_()
      local hide_views0
      local function _38_(...)
        return hide_views(config, ...)
      end
      hide_views0 = _38_
      local reverse = (config.reverse or false)
      local layout = (config.layout or nil)
      local mappings = (config.mappings or nil)
      local producer0 = consumer(producer)
      local select = select_file.select
      local multiselect = select_file.multiselect
      local initial_filter = get_initial_filter(config)
      local views = {snap.get("preview.file")}
      return snap.run({prompt = prompt, mappings = mappings, layout = layout, reverse = reverse, producer = producer0, select = select, multiselect = multiselect, views = views, hide_views = hide_views0, initial_filter = initial_filter})
    end
    return _37_
  end
  return _16_(...)
end
file = setmetatable({with = with}, {__call = _15_})
do end (_2amodule_2a)["file"] = file
local function vimgrep_prompt_by_kind(kind)
  local _39_ = kind
  if (_39_ == "ripgrep.vimgrep") then
    return "Rg Vimgrep"
  elseif true then
    local _0 = _39_
    return "Custom Vimgrep"
  else
    return nil
  end
end
local vimgrep
local function _41_(self_1_auto, ...)
  local function _42_(config)
    assert((type(config) == "table"))
    if config.prompt then
      assert((type(config.prompt) == "string"), "vimgrep.prompt must be a string")
    else
    end
    if config.limit then
      assert((type(config.limit) == "number"), "vimgrep.limit must be a number")
    else
    end
    if config.layout then
      assert((type(config.layout) == "function"), "vimgrep.layout must be a function")
    else
    end
    if config.args then
      assert((type(config.args) == "table"), "vimgrep.args must be a table")
    else
    end
    if config.hidden then
      assert((type(config.hidden) == "boolean"), "vimgrep.hidden must be a boolean")
    else
    end
    if config.suffix then
      assert((type(config.suffix) == "string"), "vimgrep.suffix must be a string")
    else
    end
    if config.reverse then
      assert((type(config.reverse) == "boolean"), "vimgrep.reverse must be a boolean")
    else
    end
    if config.preview then
      assert((type(config.preview) == "boolean"), "vimgrep.preview must be a boolean")
    else
    end
    if config.mappings then
      assert((type(config.mappings) == "table"), "vimgrep.mappings must be a table")
    else
    end
    local producer_kind = (config.producer or "ripgrep.vimgrep")
    local producer
    do
      local _52_ = producer_kind
      if (_52_ == "ripgrep.vimgrep") then
        producer = snap.get("producer.ripgrep.vimgrep")
      else
        local function _53_()
          local p = _52_
          return (type(p) == "function")
        end
        if ((nil ~= _52_) and _53_()) then
          local p = _52_
          producer = p
        elseif true then
          local _0 = _52_
          producer = assert(false, "vimgrep.producer is invalid")
        else
          producer = nil
        end
      end
    end
    if (producer_kind == "ripgrep.vimgrep") then
      if config.args then
        producer = producer.args(config.args)
      elseif config.hidden then
        producer = producer.hidden
      else
      end
    else
    end
    local consumer
    if config.limit then
      local _57_ = config.limit
      local function _58_(...)
        return snap.get("consumer.limit")(_57_, ...)
      end
      consumer = _58_
    else
      local function _59_(producer0)
        return producer0
      end
      consumer = _59_
    end
    local format_prompt0
    do
      local _61_ = config.suffix
      local function _62_(...)
        return format_prompt(_61_, ...)
      end
      format_prompt0 = _62_
    end
    local prompt
    local function _63_()
      if config.prompt then
        return config.prompt
      elseif producer_kind then
        return vimgrep_prompt_by_kind(producer_kind)
      else
        return nil
      end
    end
    prompt = format_prompt0(_63_())
    local vimgrep_select = snap.get("select.vimgrep")
    local function _64_()
      local hide_views0
      local function _65_(...)
        return hide_views(config, ...)
      end
      hide_views0 = _65_
      local reverse = (config.reverse or false)
      local layout = (config.layout or nil)
      local mappings = (config.mappings or nil)
      local producer0 = consumer(producer)
      local select = vimgrep_select.select
      local multiselect = vimgrep_select.multiselect
      local initial_filter = get_initial_filter(config)
      local views = {snap.get("preview.vimgrep")}
      return snap.run({prompt = prompt, layout = layout, reverse = reverse, mappings = mappings, producer = producer0, select = select, multiselect = multiselect, views = views, hide_views = hide_views0, initial_filter = initial_filter})
    end
    return _64_
  end
  return _42_(...)
end
vimgrep = setmetatable({with = with}, {__call = _41_})
do end (_2amodule_2a)["vimgrep"] = vimgrep
return _2amodule_2a