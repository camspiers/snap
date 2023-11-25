local _2afile_2a = "fnl/snap/init.fnl"
local _2amodule_name_2a = "snap"
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
local buffer, config, create_producer, input, register, request, results, tbl, view, window, _ = require("snap.common.buffer"), require("snap.config"), require("snap.producer.create"), require("snap.view.input"), require("snap.common.register"), require("snap.producer.request"), require("snap.view.results"), require("snap.common.tbl"), require("snap.view.view"), require("snap.common.window"), nil
_2amodule_locals_2a["buffer"] = buffer
_2amodule_locals_2a["config"] = config
_2amodule_locals_2a["create-producer"] = create_producer
_2amodule_locals_2a["input"] = input
_2amodule_locals_2a["register"] = register
_2amodule_locals_2a["request"] = request
_2amodule_locals_2a["results"] = results
_2amodule_locals_2a["tbl"] = tbl
_2amodule_locals_2a["view"] = view
_2amodule_locals_2a["window"] = window
_2amodule_locals_2a["_"] = _
local register0 = register
_2amodule_2a["register"] = register0
local config0 = config
_2amodule_2a["config"] = config0
local function map(key, run, opts)
  assert((type(key) == "string"), "map key argument must be a string")
  assert((type(run) == "function"), "map run argument must be a function")
  local command
  do
    local _1_ = type(opts)
    if (_1_ == "string") then
      print("[Snap API] The third argument to snap.map is now a table, treating passed string as command, this will be deprecated")
      command = opts
    elseif (_1_ == "table") then
      command = opts.command
    elseif (_1_ == "nil") then
      command = nil
    else
      command = nil
    end
  end
  if command then
    assert((type(command) == "string"), "map command argument must be a string")
  else
  end
  local modes
  do
    local _4_ = type(opts)
    if (_4_ == "table") then
      modes = (opts.modes or "n")
    elseif (_4_ == "nil") then
      modes = "n"
    else
      modes = nil
    end
  end
  local desc
  local _7_
  do
    local t_6_ = opts
    if (nil ~= t_6_) then
      t_6_ = (t_6_).desc
    else
    end
    _7_ = t_6_
  end
  if (_7_ ~= nil) then
    desc = opts.desc
  elseif (command ~= nil) then
    desc = ("Snap " .. command)
  else
    desc = nil
  end
  register0.map(modes, key, run, {desc = desc})
  if command then
    return register0.command(command, run)
  else
    return nil
  end
end
_2amodule_2a["map"] = map
local function maps(config1)
  for _0, _11_ in ipairs(config1) do
    local _each_12_ = _11_
    local key = _each_12_[1]
    local run = _each_12_[2]
    local opts = _each_12_[3]
    map(key, run, opts)
  end
  return nil
end
_2amodule_2a["maps"] = maps
local function get_producer(producer)
  local _13_ = type(producer)
  if (_13_ == "table") then
    return producer.default
  elseif true then
    local _0 = _13_
    return producer
  else
    return nil
  end
end
_2amodule_2a["get_producer"] = get_producer
local function get(mod)
  return require(string.format("snap.%s", mod))
end
_2amodule_2a["get"] = get
local function sync(value)
  assert((type(value) == "function"), "value passed to snap.sync must be a function")
  return select(2, coroutine.yield(value))
end
_2amodule_2a["sync"] = sync
local continue_value = {continue = true}
_2amodule_2a["continue_value"] = continue_value
local function continue(on_cancel)
  if on_cancel then
    assert((type(on_cancel) == "function"), "on-cancel provided to snap.continue must be a function")
  else
  end
  return coroutine.yield(continue_value, on_cancel)
end
_2amodule_2a["continue"] = continue
local function async(executor)
  assert((type(executor) == "function"), "executor provided to snap.async must be a function")
  local value = nil
  local error = nil
  local function resolve(val)
    value = val
    return nil
  end
  local function reject(err)
    error = err
    return nil
  end
  local function _16_()
    return executor(resolve, reject)
  end
  sync(_16_)
  while ((value == nil) and (error == nil)) do
    continue()
  end
  return value, error
end
_2amodule_2a["async"] = async
local function resume(thread, request0, value)
  assert((type(thread) == "thread"), "thread passed to snap.resume must be a thread")
  local _0, result = coroutine.resume(thread, request0, value)
  if request0.canceled() then
    return nil
  elseif (type(result) == "function") then
    return resume(thread, request0, sync(result))
  else
    return result
  end
end
_2amodule_2a["resume"] = resume
local function consume(producer, request0)
  local producer0 = get_producer(producer)
  assert((type(producer0) == "function"), "producer passed to snap.consume must be a function")
  assert((type(request0) == "table"), "request passed to snap.consume must be a table")
  local reader = coroutine.create(producer0)
  local function _18_()
    if (coroutine.status(reader) == "dead") then
      reader = nil
      return nil
    else
      return resume(reader, request0)
    end
  end
  return _18_
end
_2amodule_2a["consume"] = consume
local meta_tbl
local function _20_(_241)
  return _241.result
end
meta_tbl = {__tostring = _20_}
_2amodule_2a["meta_tbl"] = meta_tbl
local function meta_result(result)
  local _21_ = type(result)
  if (_21_ == "string") then
    local meta_result0 = {result = result}
    setmetatable(meta_result0, meta_tbl)
    return meta_result0
  elseif (_21_ == "table") then
    assert((getmetatable(result) == meta_tbl), "result has wrong metatable")
    return result
  elseif true then
    local _0 = _21_
    return assert(false, "result passed to snap.meta_result must be a string or meta result")
  else
    return nil
  end
end
_2amodule_2a["meta_result"] = meta_result
local function with_meta(result, field, value)
  assert((type(field) == "string"), "field passed to snap.with_meta must be a string")
  local meta_result0 = meta_result(result)
  do end (meta_result0)[field] = value
  return meta_result0
end
_2amodule_2a["with_meta"] = with_meta
local function with_metas(result, metas)
  assert((type(metas) == "table"), "metas passed to snap.with_metas must be a table")
  local meta_result0 = meta_result(result)
  for field, value in pairs(metas) do
    meta_result0[field] = value
  end
  return meta_result0
end
_2amodule_2a["with_metas"] = with_metas
local function has_meta(result, field)
  assert((type(field) == "string"), "field passed to snap.has_meta must be a string")
  return ((getmetatable(result) == meta_tbl) and (result[field] ~= nil))
end
_2amodule_2a["has_meta"] = has_meta
local function run(config1)
  assert((type(config1) == "table"), "snap.run config must be a table")
  assert((type(get_producer(config1.producer)) == "function"), "snap.run 'producer' must be a function or a table with a default function")
  assert((type(config1.select) == "function"), "snap.run 'select' must be a function")
  if config1.multiselect then
    assert((type(config1.multiselect) == "function"), "snap.run 'multiselect' must be a function")
  else
  end
  if config1.prompt then
    assert((type(config1.prompt) == "string"), "snap.run 'prompt' must be a string")
  else
  end
  if config1.layout then
    assert((type(config1.layout) == "function"), "snap.run 'layout' must be a function")
  else
  end
  if config1.hide_views then
    assert(vim.tbl_contains({"boolean", "function"}, type(config1.hide_views)), "snap.run 'hide_views' must be a boolean or a function")
  else
  end
  if config1.views then
    assert((type(config1.views) == "table"), "snap.run 'views' must be a table")
  else
  end
  if config1.views then
    for _0, view0 in ipairs(config1.views) do
      assert((type(view0) == "function"), "snap.run each view in 'views' must be a function")
    end
  else
  end
  if config1.loading then
    assert((type(config1.loading) == "function"), "snap.run 'loading' must be a function")
  else
  end
  if config1.reverse then
    assert((type(config1.reverse) == "boolean"), "snap.run 'reverse' must be a boolean")
  else
  end
  if config1.initial_filter then
    assert((type(config1.initial_filter) == "string"), "snap.run 'initial_filter' must be a string")
  else
  end
  if config1.autoselect then
    assert((type(config1.autoselect) == "function"), "snap.run 'autoselect' must be a function")
  else
  end
  local last_results = {}
  local last_requested_filter = ""
  local last_requested_selection = nil
  local exit = false
  local layout = (config1.layout or (get("layout")).centered)
  local autoselect = config1.autoselect
  local loading = (config1.loading or get("loading"))
  local initial_filter = (config1.initial_filter or "")
  local original_winnr = vim.api.nvim_get_current_win()
  local prompt = string.format("%s ", (config1.prompt or "Find>"))
  local selected = {}
  local cursor_row = 1
  local hide_views = nil
  local function get_hide_views()
    if (hide_views ~= nil) then
      return hide_views
    elseif (config1.hide_views ~= nil) then
      local _33_ = type(config1.hide_views)
      if (_33_ == "function") then
        return config1.hide_views()
      elseif (_33_ == "boolean") then
        return config1.hide_views
      else
        return nil
      end
    else
      return false
    end
  end
  local input_view = nil
  local results_view = nil
  local views = {}
  local function get_selection()
    return last_results[cursor_row]
  end
  local function on_exit()
    exit = true
    last_results = {}
    selected = nil
    config1["producer"] = nil
    config1["views"] = nil
    for _0, _36_ in ipairs(views) do
      local _each_37_ = _36_
      local view0 = _each_37_["view"]
      view0:delete()
    end
    results_view:delete()
    input_view:delete()
    vim.api.nvim_set_current_win(original_winnr)
    return vim.api.nvim_command("stopinsert")
  end
  local total_views
  if config1.views then
    total_views = #config1.views
  else
    total_views = 0
  end
  local function has_views()
    return ((total_views > 0) and not get_hide_views())
  end
  local function create_views()
    if has_views() then
      for index, producer in ipairs(config1.views) do
        local view0 = {view = view.create({layout = layout, index = index, ["total-views"] = total_views}), producer = producer}
        table.insert(views, view0)
      end
      return nil
    else
      return nil
    end
  end
  create_views()
  results_view = results.create({layout = layout, ["has-views"] = has_views, reverse = config1.reverse})
  local function update_cursor()
    return vim.api.nvim_win_set_cursor(results_view.winnr, {cursor_row, 0})
  end
  local update_views
  do
    local body_2_auto
    local function _40_(selection)
      for _0, _41_ in ipairs(views) do
        local _each_42_ = _41_
        local _each_43_ = _each_42_["view"]
        local bufnr = _each_43_["bufnr"]
        local winnr = _each_43_["winnr"]
        local width = _each_43_["width"]
        local height = _each_43_["height"]
        local producer = _each_42_["producer"]
        local function cancel(request0)
          return (exit or (tostring(request0.selection) ~= tostring(get_selection())))
        end
        local body = {selection = selection, bufnr = bufnr, winnr = winnr, width = width, height = height}
        local request0 = request.create({body = body, cancel = cancel})
        create_producer({producer = producer, request = request0})
      end
      return nil
    end
    body_2_auto = _40_
    local args_3_auto = nil
    local function _44_(...)
      if (args_3_auto == nil) then
        args_3_auto = {...}
        local function _45_()
          local actual_args_4_auto = args_3_auto
          args_3_auto = nil
          return body_2_auto(unpack(actual_args_4_auto))
        end
        return vim.schedule(_45_)
      else
        args_3_auto = {...}
        return nil
      end
    end
    update_views = _44_
  end
  local write_results
  do
    local body_2_auto
    local function _47_(results0, force_views)
      if not exit then
        do
          local result_size = #results0
          if (cursor_row > result_size) then
            cursor_row = math.max(1, result_size)
          else
          end
          if (result_size == 0) then
            buffer["set-lines"](results_view.bufnr, 0, -1, {})
            update_cursor()
          else
            local max = (results_view.height + cursor_row)
            local partial_results = {}
            for _0, result in ipairs(results0) do
              if (max == #partial_results) then break end
              table.insert(partial_results, tostring(result))
            end
            buffer["set-lines"](results_view.bufnr, 0, -1, partial_results)
            update_cursor()
            for row in pairs(partial_results) do
              local result = (results0)[row]
              if has_meta(result, "positions") then
                local function _50_()
                  local _49_ = type(result.positions)
                  if (_49_ == "table") then
                    return result.positions
                  elseif (_49_ == "function") then
                    return result:positions()
                  elseif true then
                    local _0 = _49_
                    return assert(false, "result positions must be a table or function")
                  else
                    return nil
                  end
                end
                buffer["add-positions-highlight"](results_view.bufnr, row, _50_())
              else
              end
              if selected[tostring(result)] then
                buffer["add-selected-highlight"](results_view.bufnr, row)
              else
              end
            end
          end
        end
        local selection = get_selection()
        if (has_views() and (force_views or (tostring(last_requested_selection) ~= tostring(selection)))) then
          last_requested_selection = selection
          for _0, _55_ in ipairs(views) do
            local _each_56_ = _55_
            local view0 = _each_56_["view"]
            local bufnr = buffer.create()
            vim.api.nvim_win_set_buf(view0.winnr, bufnr)
            buffer.delete(view0.bufnr)
            do end (view0)["bufnr"] = bufnr
          end
          if (selection ~= nil) then
            return update_views(selection)
          else
            return nil
          end
        else
          return nil
        end
      else
        return nil
      end
    end
    body_2_auto = _47_
    local args_3_auto = nil
    local function _60_(...)
      if (args_3_auto == nil) then
        args_3_auto = {...}
        local function _61_()
          local actual_args_4_auto = args_3_auto
          args_3_auto = nil
          return body_2_auto(unpack(actual_args_4_auto))
        end
        return vim.schedule(_61_)
      else
        args_3_auto = {...}
        return nil
      end
    end
    write_results = _60_
  end
  local function on_update(filter)
    last_requested_filter = filter
    local early_write = false
    local loading_count = 0
    local first_time = vim.loop.now()
    local last_time = first_time
    local results0 = {}
    local function cancel(request0)
      return (exit or (request0.filter ~= last_requested_filter))
    end
    local body = {filter = filter, height = results_view.height, winnr = original_winnr}
    local request0 = request.create({body = body, cancel = cancel})
    local config2 = {producer = get_producer(config1.producer), request = request0}
    local write_loading
    do
      local body_2_auto
      local function _63_()
        if not request0.canceled() then
          local loading_screen = loading(results_view.width, results_view.height, loading_count)
          return buffer["set-lines"](results_view.bufnr, 0, -1, loading_screen)
        else
          return nil
        end
      end
      body_2_auto = _63_
      local args_3_auto = nil
      local function _65_(...)
        if (args_3_auto == nil) then
          args_3_auto = {...}
          local function _66_()
            local actual_args_4_auto = args_3_auto
            args_3_auto = nil
            return body_2_auto(unpack(actual_args_4_auto))
          end
          return vim.schedule(_66_)
        else
          args_3_auto = {...}
          return nil
        end
      end
      write_loading = _65_
    end
    config2["on-end"] = function()
      if (#results0 == 0) then
        last_results = results0
        write_results(last_results)
      elseif ((autoselect ~= nil) and (#results0 == 1)) then
        vim.schedule_wrap(on_exit)()
        vim.schedule_wrap(autoselect)((results0)[1])
      elseif has_meta(tbl.first(results0), "score") then
        local function _68_(_241, _242)
          return (_241.score and _242.score and (_241.score > _242.score))
        end
        tbl["partial-quicksort"](results0, 1, #results0, (results_view.height + cursor_row), _68_)
        last_results = results0
        write_results(last_results)
      else
      end
      results0 = {}
      return nil
    end
    config2["on-tick"] = function()
      if not early_write then
        local current_time = vim.loop.now()
        if (((loading_count == 0) and ((current_time - first_time) > 100)) or ((current_time - last_time) > 500)) then
          loading_count = (loading_count + 1)
          last_time = current_time
          return write_loading()
        else
          return nil
        end
      else
        return nil
      end
    end
    config2["on-value"] = function(value)
      assert((type(value) == "table"), "Main producer yielded a non-yieldable value")
      if (#value > 0) then
        tbl.acc(results0, value)
        if not has_meta(tbl.first(results0), "score") then
          early_write = true
          last_results = results0
          return write_results(last_results)
        else
          return nil
        end
      else
        return nil
      end
    end
    return create_producer(config2)
  end
  local function on_enter(type)
    local selections = vim.tbl_keys(selected)
    if (#selections == 0) then
      local selection = get_selection()
      if (selection ~= nil) then
        return vim.schedule_wrap(config1.select)(selection, original_winnr, type)
      else
        return nil
      end
    elseif config1.multiselect then
      return vim.schedule_wrap(config1.multiselect)(selections, original_winnr)
    else
      return nil
    end
  end
  local function on_select_all_toggle()
    if config1.multiselect then
      for _0, value in ipairs(last_results) do
        local value0 = tostring(value)
        if selected[value0] then
          selected[value0] = nil
        else
          selected[value0] = true
        end
      end
      return write_results(last_results)
    else
      return nil
    end
  end
  local function on_select_toggle()
    if config1.multiselect then
      local selection = get_selection()
      if (selection ~= nil) then
        local value = tostring(selection)
        if selected[value] then
          selected[value] = nil
          return nil
        else
          selected[value] = true
          return nil
        end
      else
        return nil
      end
    else
      return nil
    end
  end
  local function on_key_direction(next_index)
    local line_count = vim.api.nvim_buf_line_count(results_view.bufnr)
    local index = math.max(1, math.min(line_count, next_index(cursor_row)))
    cursor_row = index
    update_cursor()
    return write_results(last_results)
  end
  local function on_prev_item()
    local function _81_(_241)
      return (_241 - 1)
    end
    return on_key_direction(_81_)
  end
  local function on_next_item()
    local function _82_(_241)
      return (_241 + 1)
    end
    return on_key_direction(_82_)
  end
  local function on_prev_page()
    local function _83_(_241)
      return (_241 - results_view.height)
    end
    return on_key_direction(_83_)
  end
  local function on_next_page()
    local function _84_(_241)
      return (_241 + results_view.height)
    end
    return on_key_direction(_84_)
  end
  local function set_next_view_row(next_index)
    if has_views() then
      local _local_85_ = tbl.first(views)
      local _local_86_ = _local_85_["view"]
      local winnr = _local_86_["winnr"]
      local bufnr = _local_86_["bufnr"]
      local height = _local_86_["height"]
      local line_count = vim.api.nvim_buf_line_count(bufnr)
      local _let_87_ = vim.api.nvim_win_get_cursor(winnr)
      local row = _let_87_[1]
      local index = math.max(1, math.min(line_count, next_index(row, height)))
      return vim.api.nvim_win_set_cursor(winnr, {index, 0})
    else
      return nil
    end
  end
  local function on_viewpageup()
    if has_views() then
      local function _89_(_241, _242)
        return (_241 - _242)
      end
      return set_next_view_row(_89_)
    else
      return nil
    end
  end
  local function on_viewpagedown()
    if has_views() then
      local function _91_(_241, _242)
        return (_241 + _242)
      end
      return set_next_view_row(_91_)
    else
      return nil
    end
  end
  local function on_next()
    if (config1.next or (config1.steps and (#config1.steps > 0))) then
      local results0 = last_results
      local next_config = {}
      for key, value in pairs(config1) do
        next_config[key] = value
      end
      local next = (config1.next or table.remove(config1.steps))
      local function _93_()
        do
          local _94_ = type(next)
          if (_94_ == "function") then
            local function _95_()
              return results0
            end
            next_config["producer"] = next(_95_)
          elseif (_94_ == "table") then
            for key, value in pairs(next.config) do
              next_config[key] = value
            end
            local _96_
            if next.format then
              _96_ = next.consumer(next.format(results0))
            else
              local function _97_()
                return results0
              end
              _96_ = next.consumer(_97_)
            end
            next_config["producer"] = _96_
          else
          end
        end
        return run(next_config)
      end
      return vim.schedule_wrap(_93_)()
    else
      return nil
    end
  end
  local function on_view_toggle_hide()
    if (hide_views == nil) then
      hide_views = not get_hide_views()
    else
      hide_views = not hide_views
    end
    results_view:update()
    input_view:update()
    if hide_views then
      for _0, _102_ in ipairs(views) do
        local _each_103_ = _102_
        local view0 = _each_103_["view"]
        view0:delete()
      end
      views = {}
      return nil
    else
      create_views()
      return write_results(last_results, true)
    end
  end
  input_view = input.create({reverse = config1.reverse, mappings = config1.mappings, ["has-views"] = has_views, layout = layout, prompt = prompt, ["on-enter"] = on_enter, ["on-next"] = on_next, ["on-exit"] = on_exit, ["on-prev-item"] = on_prev_item, ["on-next-item"] = on_next_item, ["on-prev-page"] = on_prev_page, ["on-next-page"] = on_next_page, ["on-viewpageup"] = on_viewpageup, ["on-viewpagedown"] = on_viewpagedown, ["on-view-toggle-hide"] = on_view_toggle_hide, ["on-select-toggle"] = on_select_toggle, ["on-select-all-toggle"] = on_select_all_toggle, ["on-update"] = on_update})
  if (initial_filter ~= "") then
    vim.api.nvim_feedkeys(initial_filter, "n", false)
  else
  end
  return nil
end
_2amodule_2a["run"] = run
local function create(config1, defaults)
  assert((type(config1) == "function"), "Config must be a function")
  local function _106_()
    return run(tbl.merge((defaults or {}), config1()))
  end
  return _106_
end
_2amodule_2a["create"] = create
return _2amodule_2a