local _2afile_2a = "fnl/snap/init.fnl"
local _0_
do
  local name_0_ = "snap"
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
    return {require("snap.common.buffer"), require("snap.config"), require("snap.producer.create"), require("snap.view.input"), require("snap.common.register"), require("snap.producer.request"), require("snap.view.results"), require("snap.common.tbl"), require("snap.view.view"), require("snap.common.window")}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {["require-macros"] = {["snap.macros"] = true}, require = {buffer = "snap.common.buffer", config = "snap.config", create = "snap.producer.create", input = "snap.view.input", register = "snap.common.register", request = "snap.producer.request", results = "snap.view.results", tbl = "snap.common.tbl", view = "snap.view.view", window = "snap.common.window"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local buffer = _local_0_[1]
local window = _local_0_[10]
local config = _local_0_[2]
local create = _local_0_[3]
local input = _local_0_[4]
local register = _local_0_[5]
local request = _local_0_[6]
local results = _local_0_[7]
local tbl = _local_0_[8]
local view = _local_0_[9]
local _2amodule_2a = _0_
local _2amodule_name_2a = "snap"
do local _ = ({nil, _0_, nil, {{nil}, nil, nil, nil}})[2] end
local register0
do
  local v_0_
  do
    local v_0_0 = register
    _0_["register"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["register"] = v_0_
  register0 = v_0_
end
local config0
do
  local v_0_
  do
    local v_0_0 = config
    _0_["config"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["config"] = v_0_
  config0 = v_0_
end
local map
do
  local v_0_
  do
    local v_0_0
    local function map0(key, run, opts)
      assert((type(key) == "string"), "map key argument must be a string")
      assert((type(run) == "function"), "map run argument must be a function")
      local command
      do
        local _3_ = type(opts)
        if (_3_ == "string") then
          print("[Snap API] The third argument to snap.map is now a table, treating passed string as command, this will be deprecated")
          command = opts
        elseif (_3_ == "table") then
          command = opts.command
        elseif (_3_ == "nil") then
          command = nil
        else
        command = nil
        end
      end
      if command then
        assert((type(command) == "string"), "map command argument must be a string")
      end
      local modes
      do
        local _5_ = type(opts)
        if (_5_ == "table") then
          modes = (opts.modes or "n")
        elseif (_5_ == "nil") then
          modes = "n"
        else
        modes = nil
        end
      end
      register0.map(modes, key, run)
      if command then
        return register0.command(command, run)
      end
    end
    v_0_0 = map0
    _0_["map"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["map"] = v_0_
  map = v_0_
end
local maps
do
  local v_0_
  do
    local v_0_0
    local function maps0(config1)
      for _, _3_ in ipairs(config1) do
        local _each_0_ = _3_
        local key = _each_0_[1]
        local run = _each_0_[2]
        local opts = _each_0_[3]
        map(key, run, opts)
      end
      return nil
    end
    v_0_0 = maps0
    _0_["maps"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["maps"] = v_0_
  maps = v_0_
end
local get_producer
do
  local v_0_
  do
    local v_0_0
    local function get_producer0(producer)
      local _3_ = type(producer)
      if (_3_ == "table") then
        return producer.default
      else
        local _ = _3_
        return producer
      end
    end
    v_0_0 = get_producer0
    _0_["get_producer"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get_producer"] = v_0_
  get_producer = v_0_
end
local get
do
  local v_0_
  do
    local v_0_0
    local function get0(mod)
      return require(string.format("snap.%s", mod))
    end
    v_0_0 = get0
    _0_["get"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["get"] = v_0_
  get = v_0_
end
local sync
do
  local v_0_
  do
    local v_0_0
    local function sync0(value)
      assert((type(value) == "function"), "value passed to snap.sync must be a function")
      return select(2, coroutine.yield(value))
    end
    v_0_0 = sync0
    _0_["sync"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["sync"] = v_0_
  sync = v_0_
end
local continue_value
do
  local v_0_
  do
    local v_0_0 = {continue = true}
    _0_["continue_value"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["continue_value"] = v_0_
  continue_value = v_0_
end
local continue
do
  local v_0_
  do
    local v_0_0
    local function continue0(on_cancel)
      if on_cancel then
        assert((type(on_cancel) == "function"), "on-cancel provided to snap.continue must be a function")
      end
      return coroutine.yield(continue_value, on_cancel)
    end
    v_0_0 = continue0
    _0_["continue"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["continue"] = v_0_
  continue = v_0_
end
local resume
do
  local v_0_
  do
    local v_0_0
    local function resume0(thread, request0, value)
      assert((type(thread) == "thread"), "thread passed to snap.resume must be a thread")
      local _, result = coroutine.resume(thread, request0, value)
      if request0.canceled() then
        return nil
      elseif (type(result) == "function") then
        return resume0(thread, request0, sync(result))
      else
        return result
      end
    end
    v_0_0 = resume0
    _0_["resume"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["resume"] = v_0_
  resume = v_0_
end
local consume
do
  local v_0_
  do
    local v_0_0
    local function consume0(producer, request0)
      local producer0 = get_producer(producer)
      assert((type(producer0) == "function"), "producer passed to snap.consume must be a function")
      assert((type(request0) == "table"), "request passed to snap.consume must be a table")
      local reader = coroutine.create(producer0)
      local function _3_()
        if (coroutine.status(reader) == "dead") then
          reader = nil
          return nil
        else
          return resume(reader, request0)
        end
      end
      return _3_
    end
    v_0_0 = consume0
    _0_["consume"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["consume"] = v_0_
  consume = v_0_
end
local meta_tbl
do
  local v_0_
  do
    local v_0_0
    local function _3_(_241)
      return _241.result
    end
    v_0_0 = {__tostring = _3_}
    _0_["meta_tbl"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["meta_tbl"] = v_0_
  meta_tbl = v_0_
end
local meta_result
do
  local v_0_
  do
    local v_0_0
    local function meta_result0(result)
      local _3_ = type(result)
      if (_3_ == "string") then
        local meta_result1 = {result = result}
        setmetatable(meta_result1, meta_tbl)
        return meta_result1
      elseif (_3_ == "table") then
        assert((getmetatable(result) == meta_tbl), "result has wrong metatable")
        return result
      else
        local _ = _3_
        return assert(false, "result passed to snap.meta_result must be a string or meta result")
      end
    end
    v_0_0 = meta_result0
    _0_["meta_result"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["meta_result"] = v_0_
  meta_result = v_0_
end
local with_meta
do
  local v_0_
  do
    local v_0_0
    local function with_meta0(result, field, value)
      assert((type(field) == "string"), "field passed to snap.with_meta must be a string")
      local meta_result0 = meta_result(result)
      do end (meta_result0)[field] = value
      return meta_result0
    end
    v_0_0 = with_meta0
    _0_["with_meta"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["with_meta"] = v_0_
  with_meta = v_0_
end
local with_metas
do
  local v_0_
  do
    local v_0_0
    local function with_metas0(result, metas)
      assert((type(metas) == "table"), "metas passed to snap.with_metas must be a table")
      local meta_result0 = meta_result(result)
      for field, value in pairs(metas) do
        meta_result0[field] = value
      end
      return meta_result0
    end
    v_0_0 = with_metas0
    _0_["with_metas"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["with_metas"] = v_0_
  with_metas = v_0_
end
local has_meta
do
  local v_0_
  do
    local v_0_0
    local function has_meta0(result, field)
      assert((type(field) == "string"), "field passed to snap.has_meta must be a string")
      return ((getmetatable(result) == meta_tbl) and (result[field] ~= nil))
    end
    v_0_0 = has_meta0
    _0_["has_meta"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["has_meta"] = v_0_
  has_meta = v_0_
end
local display
do
  local v_0_
  do
    local v_0_0
    local function display0(result)
      local display_fn
      if has_meta(result, "display") then
        assert((type(result.display) == "function"), "display meta must be a function")
        display_fn = result.display
      else
        display_fn = tostring
      end
      return display_fn(result)
    end
    v_0_0 = display0
    _0_["display"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["display"] = v_0_
  display = v_0_
end
local run
do
  local v_0_
  do
    local v_0_0
    local function run0(config1)
      assert((type(config1) == "table"), "snap.run config must be a table")
      assert((type(get_producer(config1.producer)) == "function"), "snap.run 'producer' must be a function or a table with a default function")
      assert((type(config1.select) == "function"), "snap.run 'select' must be a function")
      if config1.multiselect then
        assert((type(config1.multiselect) == "function"), "snap.run 'multiselect' must be a function")
      end
      if config1.prompt then
        assert((type(config1.prompt) == "string"), "snap.run 'prompt' must be a string")
      end
      if config1.layout then
        assert((type(config1.layout) == "function"), "snap.run 'layout' must be a function")
      end
      if config1.hide_views then
        assert(vim.tbl_contains({"boolean", "function"}, type(config1.hide_views)), "snap.run 'hide_views' must be a boolean or a function")
      end
      if config1.views then
        assert((type(config1.views) == "table"), "snap.run 'views' must be a table")
      end
      if config1.views then
        for _, view0 in ipairs(config1.views) do
          assert((type(view0) == "function"), "snap.run each view in 'views' must be a function")
        end
      end
      if config1.loading then
        assert((type(config1.loading) == "function"), "snap.run 'loading' must be a function")
      end
      if config1.reverse then
        assert((type(config1.reverse) == "boolean"), "snap.run 'reverse' must be a boolean")
      end
      if config1.initial_filter then
        assert((type(config1.initial_filter) == "string"), "snap.run 'initial_filter' must be a string")
      end
      local last_results = {}
      local last_requested_filter = ""
      local last_requested_selection = nil
      local exit = false
      local layout = (config1.layout or (get("layout")).centered)
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
          local _12_ = type(config1.hide_views)
          if (_12_ == "function") then
            return config1.hide_views()
          elseif (_12_ == "boolean") then
            return config1.hide_views
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
        for _, _12_ in ipairs(views) do
          local _each_0_ = _12_
          local view0 = _each_0_["view"]
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
            local view0 = {producer = producer, view = view.create({["total-views"] = total_views, index = index, layout = layout})}
            table.insert(views, view0)
          end
          return nil
        end
      end
      create_views()
      results_view = results.create({["has-views"] = has_views, layout = layout, reverse = config1.reverse})
      local function update_cursor()
        return vim.api.nvim_win_set_cursor(results_view.winnr, {cursor_row, 0})
      end
      local update_views
      do
        local body_0_
        local function _13_(selection)
          for _, _14_ in ipairs(views) do
            local _each_0_ = _14_
            local producer = _each_0_["producer"]
            local _each_1_ = _each_0_["view"]
            local bufnr = _each_1_["bufnr"]
            local height = _each_1_["height"]
            local width = _each_1_["width"]
            local winnr = _each_1_["winnr"]
            local function cancel(request0)
              return (exit or (tostring(request0.selection) ~= tostring(get_selection())))
            end
            local body = {bufnr = bufnr, height = height, selection = selection, width = width, winnr = winnr}
            local request0 = request.create({body = body, cancel = cancel})
            create({producer = producer, request = request0})
          end
          return nil
        end
        body_0_ = _13_
        local args_0_ = nil
        local function _14_(...)
          if (args_0_ == nil) then
            args_0_ = {...}
            local function _15_()
              local actual_args_0_ = args_0_
              args_0_ = nil
              return body_0_(unpack(actual_args_0_))
            end
            return vim.schedule(_15_)
          else
            args_0_ = {...}
            return nil
          end
        end
        update_views = _14_
      end
      local write_results
      do
        local body_0_
        local function _13_(results0, force_views)
          if not exit then
            do
              local result_size = #results0
              if (cursor_row > result_size) then
                cursor_row = math.max(1, result_size)
              end
              if (result_size == 0) then
                buffer["set-lines"](results_view.bufnr, 0, -1, {})
                update_cursor()
              else
                local max = (results_view.height + cursor_row)
                local partial_results = {}
                for _, result in ipairs(results0) do
                  if (max == #partial_results) then break end
                  table.insert(partial_results, display(result))
                end
                buffer["set-lines"](results_view.bufnr, 0, -1, partial_results)
                update_cursor()
                for row in pairs(partial_results) do
                  local result = (results0)[row]
                  if has_meta(result, "positions") then
                    local function _16_()
                      local _15_ = type(result.positions)
                      if (_15_ == "table") then
                        return result.positions
                      elseif (_15_ == "function") then
                        return result:positions()
                      else
                        local _ = _15_
                        return assert(false, "result positions must be a table or function")
                      end
                    end
                    buffer["add-positions-highlight"](results_view.bufnr, row, _16_())
                  end
                  if selected[tostring(result)] then
                    buffer["add-selected-highlight"](results_view.bufnr, row)
                  end
                end
              end
            end
            local selection = get_selection()
            if (has_views() and (force_views or (tostring(last_requested_selection) ~= tostring(selection)))) then
              last_requested_selection = selection
              for _, _14_ in ipairs(views) do
                local _each_0_ = _14_
                local view0 = _each_0_["view"]
                local bufnr = buffer.create()
                vim.api.nvim_win_set_buf(view0.winnr, bufnr)
                buffer.delete(view0.bufnr, {force = true})
                do end (view0)["bufnr"] = bufnr
              end
              if (selection ~= nil) then
                return update_views(selection)
              end
            end
          end
        end
        body_0_ = _13_
        local args_0_ = nil
        local function _14_(...)
          if (args_0_ == nil) then
            args_0_ = {...}
            local function _15_()
              local actual_args_0_ = args_0_
              args_0_ = nil
              return body_0_(unpack(actual_args_0_))
            end
            return vim.schedule(_15_)
          else
            args_0_ = {...}
            return nil
          end
        end
        write_results = _14_
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
          local body_0_
          local function _13_()
            if not request0.canceled() then
              local loading_screen = loading(results_view.width, results_view.height, loading_count)
              return buffer["set-lines"](results_view.bufnr, 0, -1, loading_screen)
            end
          end
          body_0_ = _13_
          local args_0_ = nil
          local function _14_(...)
            if (args_0_ == nil) then
              args_0_ = {...}
              local function _15_()
                local actual_args_0_ = args_0_
                args_0_ = nil
                return body_0_(unpack(actual_args_0_))
              end
              return vim.schedule(_15_)
            else
              args_0_ = {...}
              return nil
            end
          end
          write_loading = _14_
        end
        config2["on-end"] = function()
          if (#results0 == 0) then
            last_results = results0
            write_results(last_results)
          elseif has_meta(tbl.first(results0), "score") then
            local function _13_(_241, _242)
              return (_241.score > _242.score)
            end
            tbl["partial-quicksort"](results0, 1, #results0, (results_view.height + cursor_row), _13_)
            last_results = results0
            write_results(last_results)
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
            end
          end
        end
        config2["on-value"] = function(value)
          assert((type(value) == "table"), string.format("Main producer yielded a non-yieldable value: %s", vim.inspect(value)))
          if (#value > 0) then
            tbl.accumulate(results0, value)
            if not has_meta(tbl.first(results0), "score") then
              early_write = true
              last_results = results0
              return write_results(last_results)
            end
          end
        end
        return create(config2)
      end
      local function on_enter(type)
        local selections = vim.tbl_keys(selected)
        if (#selections == 0) then
          local selection = get_selection()
          if (selection ~= nil) then
            return vim.schedule_wrap(config1.select)(selection, original_winnr, type)
          end
        elseif config1.multiselect then
          return vim.schedule_wrap(config1.multiselect)(selections, original_winnr)
        end
      end
      local function on_select_all_toggle()
        if config1.multiselect then
          for _, value in ipairs(last_results) do
            local value0 = tostring(value)
            if selected[value0] then
              selected[value0] = nil
            else
              selected[value0] = true
            end
          end
          return write_results(last_results)
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
          end
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
        local function _13_(_241)
          return (_241 - 1)
        end
        return on_key_direction(_13_)
      end
      local function on_next_item()
        local function _13_(_241)
          return (_241 + 1)
        end
        return on_key_direction(_13_)
      end
      local function on_prev_page()
        local function _13_(_241)
          return (_241 - results_view.height)
        end
        return on_key_direction(_13_)
      end
      local function on_next_page()
        local function _13_(_241)
          return (_241 + results_view.height)
        end
        return on_key_direction(_13_)
      end
      local function set_next_view_row(next_index)
        if has_views() then
          local _local_1_ = tbl.first(views)
          local _local_2_ = _local_1_["view"]
          local bufnr = _local_2_["bufnr"]
          local height = _local_2_["height"]
          local winnr = _local_2_["winnr"]
          local line_count = vim.api.nvim_buf_line_count(bufnr)
          local _let_0_ = vim.api.nvim_win_get_cursor(winnr)
          local row = _let_0_[1]
          local index = math.max(1, math.min(line_count, next_index(row, height)))
          return vim.api.nvim_win_set_cursor(winnr, {index, 0})
        end
      end
      local function on_viewpageup()
        if has_views() then
          local function _13_(_241, _242)
            return (_241 - _242)
          end
          return set_next_view_row(_13_)
        end
      end
      local function on_viewpagedown()
        if has_views() then
          local function _13_(_241, _242)
            return (_241 + _242)
          end
          return set_next_view_row(_13_)
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
          local function _13_()
            do
              local _14_ = type(next)
              if (_14_ == "function") then
                local function _15_()
                  return results0
                end
                next_config["producer"] = next(_15_)
              elseif (_14_ == "table") then
                for key, value in pairs(next.config) do
                  next_config[key] = value
                end
                local _15_
                if next.format then
                  _15_ = next.consumer(next.format(results0))
                else
                  local function _16_()
                    return results0
                  end
                  _15_ = next.consumer(_16_)
                end
                next_config["producer"] = _15_
              end
            end
            return run0(next_config)
          end
          return vim.schedule_wrap(_13_)()
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
          for _, _14_ in ipairs(views) do
            local _each_0_ = _14_
            local view0 = _each_0_["view"]
            view0:delete()
          end
          views = {}
          return nil
        else
          create_views()
          vim.api.nvim_set_current_win(input_view.winnr)
          return write_results(last_results, true)
        end
      end
      input_view = input.create({["has-views"] = has_views, ["on-enter"] = on_enter, ["on-exit"] = on_exit, ["on-next"] = on_next, ["on-next-item"] = on_next_item, ["on-next-page"] = on_next_page, ["on-prev-item"] = on_prev_item, ["on-prev-page"] = on_prev_page, ["on-select-all-toggle"] = on_select_all_toggle, ["on-select-toggle"] = on_select_toggle, ["on-update"] = on_update, ["on-view-toggle-hide"] = on_view_toggle_hide, ["on-viewpagedown"] = on_viewpagedown, ["on-viewpageup"] = on_viewpageup, layout = layout, mappings = config1.mappings, prompt = prompt, reverse = config1.reverse})
      if (initial_filter ~= "") then
        vim.api.nvim_feedkeys(initial_filter, "n", false)
      end
      return nil
    end
    v_0_0 = run0
    _0_["run"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["run"] = v_0_
  run = v_0_
end
local create0
do
  local v_0_
  do
    local v_0_0
    local function create1(config1, defaults)
      assert((type(config1) == "function"), "Config must be a function")
      local function _3_()
        return run(tbl.merge((defaults or {}), config1()))
      end
      return _3_
    end
    v_0_0 = create1
    _0_["create"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["create"] = v_0_
  create0 = v_0_
end
return nil