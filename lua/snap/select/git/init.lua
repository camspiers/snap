local _2afile_2a = "fnl/snap/select/git/init.fnl"
local snap = require("snap")
local layout = require("snap.layout")
local tbl = require("snap.common.tbl")
local snap_string = require("snap.common.string")
local filter
if pcall(require, "fzy") then
  filter = require("snap.consumer.fzy")
else
  filter = require("snap.consumer.fzf")
end
local function action_layout(actions)
  local columns = layout.columns()
  local lines = layout.lines()
  local max_length = tbl["max-length"](actions)
  local width = (max_length * 3)
  local height = (#actions + 3)
  return {width = width, height = height, col = layout.middle(columns, width), row = layout.middle(lines, height)}
end
local function checkout(selection, on_done)
  local function _2_(_241)
    local _3_ = _241.code
    if (_3_ == 0) then
      if on_done then
        vim.schedule(on_done)
      else
      end
      return vim.notify(string.format("Checked out '%s'", tostring(selection)), vim.log.levels.INFO)
    elseif true then
      local _ = _3_
      return vim.notify(string.format("Error when checking out '%s':\n%s", tostring(selection), _241.stderr), vim.log.levels.ERROR)
    else
      return nil
    end
  end
  return vim.system({"git", "checkout", tostring(selection)}, {cwd = vim.fn.getcwd()}, _2_)
end
local function reset_soft(selection)
  local function _6_(_241)
    if (_241.code == 0) then
      return vim.notify(string.format("Soft reset '%s'", tostring(selection)), vim.log.levels.INFO)
    else
      return nil
    end
  end
  return vim.system({"git", "reset", "--soft", tostring(selection)}, {cwd = vim.fn.getcwd()}, _6_)
end
local function reset_hard(selection)
  local function _8_(_241)
    if (_241.code == 0) then
      return vim.notify(string.format("Hard reset '%s'", tostring(selection)), vim.log.levels.INFO)
    else
      return nil
    end
  end
  return vim.system({"git", "reset", "--hard", tostring(selection)}, {cwd = vim.fn.getcwd()}, _8_)
end
local function pull(branch, remote)
  local function _10_()
    local function _11_(_2410)
      if (_2410.code == 0) then
        return vim.notify(string.format("Pulled '%s/%s'", tostring(remote), tostring(branch)), vim.log.levels.INFO)
      else
        return nil
      end
    end
    return vim.system({"git", "pull", tostring(remote), tostring(branch)}, {cwd = vim.fn.getcwd()}, _11_)
  end
  return checkout(branch, _10_)
end
local function pull_list(branch)
  local function _13_(_241)
    if (_241.code == 0) then
      local remotes = snap_string.split(_241.stdout)
      local function _14_()
        local function _15_()
          return remotes
        end
        local function _16_(...)
          return vim.schedule_wrap(pull)(branch, ...)
        end
        local function _17_(...)
          return action_layout(remotes, ...)
        end
        return snap.run({prompt = "Select>", producer = filter(_15_), select = _16_, layout = _17_})
      end
      return vim.schedule(_14_)
    else
      return nil
    end
  end
  return vim.system({"git", "remote"}, {cwd = vim.fn.getcwd()}, _13_)
end
local branch_actions
local function _19_(_241)
  return snap.with_metas(_241.label, _241)
end
branch_actions = vim.tbl_map(_19_, {{label = "Checkout", action = checkout}, {label = "Reset (soft)", action = reset_soft}, {label = "Reset (hard)", action = reset_hard}, {label = "Pull", action = pull_list}})
local function branch(selection)
  local function _20_()
    return branch_actions
  end
  local function _21_(_241)
    return _241.action(selection)
  end
  local function _22_(...)
    return action_layout(branch_actions, ...)
  end
  return snap.run({prompt = "Select>", producer = filter(_20_), select = _21_, layout = _22_})
end
return {branch = branch}