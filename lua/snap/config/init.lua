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
      local _30_ = consumer_kind
      if (_30_ == "fzf") then
        consumer = snap.get("consumer.fzf")
      elseif (_30_ == "fzy") then
        consumer = snap.get("consumer.fzy")
      else
        local function _31_()
          local c = _30_
          return (type(c) == "function")
        end
        if ((nil ~= _30_) and _31_()) then
          local c = _30_
          consumer = c
        elseif true then
          local _0 = _30_
          consumer = assert(false, "file.consumer is invalid")
        else
          consumer = nil
        end
      end
    end
    local add_prompt_suffix
    do
      local _33_ = config.suffix
      local function _34_(...)
        return format_prompt(_33_, ...)
      end
      add_prompt_suffix = _34_
    end
    local prompt
    local function _35_()
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
    prompt = add_prompt_suffix(_35_())
    local select_file = snap.get("select.file")
    local function _36_()
      local hide_views0
      local function _37_(...)
        return hide_views(config, ...)
      end
      hide_views0 = _37_
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
    return _36_
  end
  return _16_(...)
end
file = setmetatable({with = with}, {__call = _15_})
do end (_2amodule_2a)["file"] = file
local function vimgrep_prompt_by_kind(kind)
  local _38_ = kind
  if (_38_ == "ripgrep.vimgrep") then
    return "Rg Vimgrep"
  elseif true then
    local _0 = _38_
    return "Custom Vimgrep"
  else
    return nil
  end
end
local vimgrep
local function _40_(self_1_auto, ...)
  local function _41_(config)
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
      local _51_ = producer_kind
      if (_51_ == "ripgrep.vimgrep") then
        producer = snap.get("producer.ripgrep.vimgrep")
      else
        local function _52_()
          local p = _51_
          return (type(p) == "function")
        end
        if ((nil ~= _51_) and _52_()) then
          local p = _51_
          producer = p
        elseif true then
          local _0 = _51_
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
      local _56_ = config.limit
      local function _57_(...)
        return snap.get("consumer.limit")(_56_, ...)
      end
      consumer = _57_
    else
      local function _58_(producer0)
        return producer0
      end
      consumer = _58_
    end
    local format_prompt0
    do
      local _60_ = config.suffix
      local function _61_(...)
        return format_prompt(_60_, ...)
      end
      format_prompt0 = _61_
    end
    local prompt
    local function _62_()
      if config.prompt then
        return config.prompt
      elseif producer_kind then
        return vimgrep_prompt_by_kind(producer_kind)
      else
        return nil
      end
    end
    prompt = format_prompt0(_62_())
    local vimgrep_select = snap.get("select.vimgrep")
    local function _63_()
      local hide_views0
      local function _64_(...)
        return hide_views(config, ...)
      end
      hide_views0 = _64_
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
    return _63_
  end
  return _41_(...)
end
vimgrep = setmetatable({with = with}, {__call = _40_})
do end (_2amodule_2a)["vimgrep"] = vimgrep
return _2amodule_2a