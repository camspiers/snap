# Snap

A fast finder system for neovim >0.5.

## Demo

The following shows finding files and grepping in the large `gcc` codebase.

https://user-images.githubusercontent.com/51294/120878813-f958f600-c612-11eb-9730-deefd39fb36e.mov


## Installation

### With Packer

```lua
use { 'camspiers/snap' }
```

or with `fzy`:

```lua
use { 'camspiers/snap', rocks = {'fzy'}}
```

### With vim-plug

```
Plug 'camspiers/snap'
```

With vim-plug you will need to use `luarocks` manually if you want to install `fzy`, probably best to just use `fzf` if you are using vim-plug.

#### Semi-Optional Dependencies

To use the following `snap` components you need the specified dependencies, however not all components are needed, for example you should probably choose between `fzy` and `fzf` as your primary consumer.

| Component            | Dependency                        |
| -------------------- | --------------------------------- |
| `consumer.fzy`       | `fzy` via luarocks                |
| `consumer.fzf`       | `fzf` available on command line   |
| `producer.ripgrep.*` | `rg` available on commmand line   |
| `producer.fd.*`      | `fd` available on commmand line   |
| `producer.git.file`  | `git` available on commmand line  |
| `preview.*`          | `file` available on commmand line |

They are semi-optional because you can mix and match them depending on which technology you want to use.

## Getting Started

There are three primary APIs to be aware of in order to set up your local nvim to use `snap`.

### `snap.maps`

`snap.maps` and `snap.map` will map a function to a particular keybinding. Any function can be registered (e.g your own lua functions), however usually you will register functions that result in a call to `snap.run`.

### `snap.config`

`snap.config` offers a terse API for creating functions that call `snap.run` with sensible configuration.

### `snap.run`

Though used directly infrequently, `snap.run` is the API to start a snap.

### Registering Global Keymaps

The following illustrates some basic usage of the `snap.maps` and `snap.config` APIs, we generate a variety of functions and register them as normal mode mappings:

```lua
local snap = require'snap'
snap.maps {
  {"<Leader><Leader>", snap.config.file {producer = "ripgrep.file"}},
  {"<Leader>fb", snap.config.file {producer = "vim.buffer"}},
  {"<Leader>fo", snap.config.file {producer = "vim.oldfile"}},
  {"<Leader>ff", snap.config.vimgrep {}},
}
```

This gives a basic example, however see the [`snap.config`](#config-api) section for all options available.

### Registering Global Keymaps With Defaults

Perhaps you want some default config to apply to all your `snap.config.file` usages, to do so you can generate your own version of `snap.config.file` or `snap.config.vimgrep` with applied defaults:

```lua
local snap = require'snap'
local file = snap.config.file:with {reverse = true, suffix = ">>", consumer = "fzy"}
local vimgrep = snap.config.vimgrep:with {reverse = true, suffix = ">>", limit = 50000}
snap.maps {
  {"<Leader><Leader>", file {producer = "ripgrep.file"}},
  {"<Leader>ff", vimgrep {}},
}
```

### Registering Global Keymaps With Registered Commands

If you want to also make your function available via the `:Snap myexamplefunction` API, you can pass an optional third parameter to `snap.map` or an optional third table value to each table to `snap.maps`.

```lua
local snap = require'snap'
snap.maps {
  {"<Leader><Leader>", snap.config.file {producer = "ripgrep.file"}, {command = "mycommandname"}}
}
```

## Config API

`snap.run` is designed to be a very general API used by composing different types of producers and consumers, instead of bundling defaults and configuration types into the general `snap.run` API, it is designed to be highly flexible and idempotent. So to ease the pain of creating your own functions that call `snap.run` with appropriate configuration, we instead provide `snap.config` for generating such functions with common configuration patterns.

### `snap.config.file`

The full API:

```typescript
{
  // One of either producer, try or combine are required

  // A required producer either by string identifier or a function
  producer: "ripgrep.file"
    | "fd.file"
    | "vim.oldfile"
    | "vim.buffer"
    | "git.file"
    | Producer,

  // A table of producers, the first that returns results is used
  try: table<
    "ripgrep.file"
    | "fd.file"
    | "vim.oldfile"
    | "vim.buffer"
    | "git.file"
    | Producer
  >,

  // A table of producers, combines returns from each
  combine: table<
    "ripgrep.file"
    | "fd.file"
    | "vim.oldfile"
    | "vim.buffer"
    | "git.file"
    | Producer
  >,

  // Optionals

  // An optional prompt string (without suffix e.g. ">")
  prompt?: string,

  // An optional suffix string e.g. ">>"
  suffix?: string,

  // An optional layout function, see layout API below
  layout?: function,

  // An optional table that passes args to producers that support it
  args?: table<string>,

  // An optional boolean that configures producers that suppport it
  hidden?: boolean,

  // An optional boolean that when true places the input at the top
  reverse?: boolean,

  // An optional number that chanes the minimun screen column width the preview should display at
  preview_min_width?: number,

  // An optional boolean or function that returning true displays the preview and when false hides
  preview?: boolean | function,

  // An optional table of custom input buffer mappings, see mappings section below for options
  mappings?: table

  // An optional string, if cword then filter using current word, if selection then use selection
  filter_with?: "cword" | "selection",

  // An optional string or function use as initial filter
  filter?: string | function
}
```

### Examples

The following `snap.config.file` calls generate functions that run `snap.run` with various defaults.

Each of these example functions generated would usually be passed to `snap.maps`, but you could also use them with any other mapping registration API, e.g. `which-key`.

```lua
-- Basic ripgrep file producer
file {producer = "ripgrep.file"}

-- Ripgrep file producer with args
file {producer = "ripgrep.file", args = {'--hidden', '--iglob', '!.git/*'}}

-- Git file producer with ripgrep fallback
file {try = {"git.file", "ripgrep.file"}}

-- Basic file producer with previews off
file {producer = "ripgrep.file", preview = false}

-- Basic buffer producer
file {producer = "vim.buffer"}

-- Basic oldfile producer
file {producer = "vim.oldfile"}

-- A customized prompt
file {producer = "ripgrep.file", prompt = "MyFiles"}

-- A customized prompt suffix
file {producer = "ripgrep.file", suffix = ">>"}

-- Display input at top
file {producer = "ripgrep.file", reverse = true}

-- Custom layout function
file {producer = "ripgrep.file", layout = myCustomLayoutFunction}
```

## Recipes

`snap` comes with inbuilt producers and consumers (see [How Snap Works](#how-snap-works) for what producers and consumers are) to enable easy creation of finders.

The following recipes illustrate direct usage of `snap.run` meaning calling the following examples will immediately run snap, but as illustrated above when registering a mapping you most often want to get a function that will invoke `snap.run` with a particular config, in that case the following examples can be replaced with invocations to `snap.config.file` to create the desired config.

### Find Files

Uses built in `fzy` filter + score, and `ripgrep` for file finding.

```lua
snap.run {
  producer = snap.get'consumer.fzy'(snap.get'producer.ripgrep.file'),
  select = snap.get'select.file'.select,
  multiselect = snap.get'select.file'.multiselect,
  views = {snap.get'preview.file'}
}
```

or using `fzf`:

```lua
snap.run {
  producer = snap.get'consumer.fzf'(snap.get'producer.ripgrep.file'),
  select = snap.get'select.file'.select,
  multiselect = snap.get'select.file'.multiselect,
  views = {snap.get'preview.file'}
}
```

### Live Ripgrep

```lua
snap.run {
  producer = snap.get'producer.ripgrep.vimgrep',
  select = snap.get'select.vimgrep'.select,
  multiselect = snap.get'select.vimgrep'.multiselect,
  views = {snap.get'preview.vimgrep'}
}
```

Or given this can easily create the ability to ripgrep your entire filesystem with a result for every character, you can set a reasonable upper limit to 10,000 matches:

```lua
snap.run {
  producer = snap.get'consumer.limit'(10000, snap.get'producer.ripgrep.vimgrep'),
  select = snap.get'select.vimgrep'.select,
  multiselect = snap.get'select.vimgrep'.multiselect,
  views = {snap.get'preview.vimgrep'}
}
```

### Find Buffers

```lua
snap.run {
  producer = snap.get'consumer.fzy'(snap.get'producer.vim.buffer'),
  select = snap.get'select.file'.select,
  multiselect = snap.get'select.file'.multiselect,
  views = {snap.get'preview.file'}
}
```

### Find Old Files

```lua
snap.run {
  producer = snap.get'consumer.fzy'(snap.get'producer.vim.oldfile'),
  select = snap.get'select.file'.select,
  multiselect = snap.get'select.file'.multiselect,
  views = {snap.get'preview.file'}
}
```

### Find Git Files

```lua
snap.run {
  producer = snap.get'consumer.fzy'(snap.get'producer.git.file'),
  select = snap.get'select.file'.select,
  multiselect = snap.get'select.file'.multiselect,
  views = {snap.get'preview.file'}
}
```

or find git files with fallback to ripgrep:

```lua
snap.run {
  producer = snap.get'consumer.fzf'(
    snap.get'consumer.try'(
      snap.get'producer.git.file',
      snap.get'producer.ripgrep.file'
    ),
  ),
  select = snap.get'select.file'.select,
  multiselect = snap.get'select.file'.multiselect,
  views = {snap.get'preview.file'}
}
```

### Find Help Tags

```lua
snap.run {
  prompt = "Help>",
  producer = snap.get'consumer.fzy'(snap.get'producer.vim.help'),
  select = snap.get'select.help'.select,
  views = {snap.get'preview.help'}
}
```

### Grep with FZF as optional next step

The following will run the vimgrep producer and upon `<C-q>` will run `fzf` on the filtered results.

```lua
snap.run {
  producer = snap.get'producer.ripgrep.vimgrep',
  steps = {{
    consumer = snap.get'consumer.fzf',
    config = {prompt = "FZF>"}
  }},
  select = snap.get'select.file'.select,
  multiselect = snap.get'select.file'.multiselect,
  views = {snap.get'preview.file'}
}
```

### Search files in multiple paths

The following will combine results from multiple paths using a producer for each path:

```lua
snap.run {
  producer = snap.get'consumer.fzf'(
    snap.get'consumer.combine'(
      snap.get'producer.ripgrep.file'.args({}, "/directory1"),
      snap.get'producer.ripgrep.file'.args({}, "/directory2"),
      snap.get'producer.ripgrep.file'.args({}, "/directory3"),
    ),
  ),
  select = snap.get'select.file'.select,
  multiselect = snap.get'select.file'.multiselect,
  views = {snap.get'preview.file'}
}
```

### Key Bindings for Input Buffer

The following are what bindings are made for the input buffer while snap is open.

#### Select

When a single item is selected, calls the provided `select` function with the cursor result as the selection.

When multiple items are selection, calls the provider `multiselect` function.

- `<CR>`

Alternatives:

- `<C-x>` opens in new split
- `<C-v>` opens in new vsplit
- `<C-t>` opens in new tab

#### Exit

Closes `snap`

- `<Esc>`
- `<C-c>`

#### Next

Move cursor to the next selection.

- `<Down>`
- `<C-n>`
- `<C-j>`

#### Previous

Move cursor to the previous selection.

- `<Up>`
- `<C-p>`
- `<C-k>`

#### Multiselect (enabled when `multiselect` is provided)

Add current cursor result to selection list.

- `<Tab>`

Remove current cursor result from selection list.

- `<S-Tab>`

Select all

- `<C-a>`

#### Results Page Down

Moves the results cursor down a page.

- `<C-b>`

#### Results Page Up

Moves the results cursor up a page.

- `<C-f>`

#### View Page Down

Moves the cursor of the first view down a page (if more than one exists).

- `<C-d>`

#### View Page Up

Moves the cursor of the first view up a page (if more than one exists).

- `<C-u>`

#### Toggle Views

Toggles the views on and off.

- `<C-h>`

### Customizing Default Input Buffer Mappings

The default mappings can be customized by providing a `mappings` key to your `snap.run` configs.

The following are the default mappings, each of which can be overridden:

```lua
{
  ["enter-split"] = {"<C-x>"},
  ["enter-tab"] = {"<C-t>"},
  ["enter-vsplit"] = {"<C-v>"},
  ["next-item"] = {"<C-n>"},
  ["next-page"] = {"<C-f>"},
  ["prev-item"] = {"<C-p>"},
  ["prev-page"] = {"<C-b>"},
  ["select-all"] = {"<C-a>"},
  ["view-page-down"] = {"<C-d>"},
  ["view-page-up"] = {"<C-u>"},
  ["view-toggle-hide"] = {"<C-h>"},
  enter = {"<CR>"},
  exit = {"<Esc>", "<C-c>"},
  next = {"<C-q>"},
  select = {"<Tab>"},
  unselect = {"<S-Tab>"}
}
```

Example:

```lua
snap.run {
  producer = snap.get'consumer.fzy'(snap.get'producer.ripgrep.file'),
  select = snap.get'select.file'.select,
  multiselect = snap.get'select.file'.multiselect,
  views = {snap.get'preview.file'},
  mappings = {
    enter = {"<CR>", "<C-o>"}, -- my custom mapping
  }
}
```

## How Snap Works

`snap` uses a non-blocking design to ensure the UI is always responsive to user input.

To achieve this it employs coroutines, and while that might be a little daunting, the following walk-through illustrates the primary concepts.

Our example's goal is to run the `ls` command, filter the results in response to input, and print the selected value.

### Producer

A producers API looks like this:

```typescript
type Producer = (request: Request) => yield<Yieldable>;
```

The producer is a function that takes a request and yields results (see below for the range of `Yieldable` types).

In the following `producer`, we run the `ls` command and progressively `yield` its output.

```lua
local snap = require'snap'
local io = snap.get'common.io'

-- Runs ls and yields lua tables containing each line
local function producer (request)
  -- Runs the slow-mode getcwd function
  local cwd = snap.sync(vim.fn.getcwd)
  -- Iterates ls commands output using snap.io.spawn
  for data, err, kill in io.spawn("ls", {}, cwd) do
    -- If the filter updates while the command is still running
    -- then we kill the process and yield nil
    if request.canceled() then
      kill()
      coroutine.yield(nil)
    -- If there is an error we yield nil
    elseif (err ~= "") then
      coroutine.yield(nil)
    -- If the data is empty we yield an empty table
    elseif (data == "") then
      coroutine.yield({})
    -- If there is data we split it by newline
    else
      coroutine.yield(vim.split(data, "\n", true))
    end
  end
end
```

### Consumer

A consumers type looks like this:

```typescript
type Consumer = (producer: Producer) => Producer;
```

A consumer is a function that takes a producer and returns a producer.

As our goal here is to filter, we iterate over our passed producer and only yield values that match `request.filter`.

```lua
-- Takes in a producer and returns a producer
local function consumer (producer)
  -- Return producer
  return function (request)
    -- Iterates over the producers results
    for results in snap.consume(producer, request) do
      -- If we have a table then we want to filter it
      if type(results) == "table" then
        -- Yield the filtered table
        coroutine.yield(vim.tbl_filter(
          function (value)
            return string.find(value, request.filter, 0, true)
          end,
          results
        ))
      -- If we don't have a table we finish by yielding nil
      else
        coroutine.yield(nil)
      end
    end
  end
end
```

### Producer + Consumer

The following combines our above `consumer` and `producer`, itself creating a new producer, and passes this to `snap` to run:

```lua
snap.run {
  producer = consumer(producer),
  select = print
}
```

From the above we have seen the following distinct concepts of `snap`:

- Producer + consumer pattern
- Yielding a lua `table` of strings
- Yielding `nil` to exit
- Using `snap.io.spawn` iterate over the data of a process
- Using `snap.sync` to run slow-mode nvim functions
- Using `snap.consume` to consume another producer
- Using the `request.filter` value
- Using the `request.canceled()` signal to kill processes


## API

### Meta Result

Results can be decorated with additional information (see `with_meta`), these results are represented by the `MetaResult` type.

```typescript
// A table that tostrings as result

type MetaResult = {
  // The result string value
  result: string;

  // A metatable __tostring implementation
  __tostring: (result: MetaResult) => string;

  // More optional properties, e.g. score
  ...
};
```

### Yieldable

Coroutines in `snap` can yield 4 different types, each with a distinct meaning outlined below.

```typescript
type Yieldable = table<string> | table<MetaResult> | function | nil;
```

#### Yielding `table<string>`

For each `table<string>` yielded (or returned as the last value of `producer`) from a `producer`, `snap` will accumulate the values of the table and display them in the results buffer.

```lua
local function producer(message)
  coroutine.yield({"Result 1", "Result 1"})
  -- the nvim UI can respond to input between these yields
  coroutine.yield({"Result 3", "Result 4"})
end
```

This `producer` function results in a table of 4 values displayed, but given there are two yields, in between these yields `nvim` has an oppurtunity to process more input.

One can see how this functionality allows for results of spawned processes to progressively yield thier results while avoiding blocking user input, and enabling the cancelation of said spawned processes.

#### Yielding `table<MetaResult>`

Results at times need to be decorated with additional information, e.g. a sort score.

`snap` makes use of tables (with an attached metatable implementing `__tostring`) to represent results with meta data.

The following shows how to add results with additional information. And because `snap` automatically sorts results with `score` meta data, the following with be ordered accordingly.

```lua
local function producer(message)
  coroutine.yield({
    snap.with_meta("Higher rank", "score", 10),
    snap.with_meta("Lower rank", "score", 1),
    snap.with_meta("Mid rank", "score", 5)
  })
end
```

#### Yielding `function`

Given that `producer` is by design run when `fast-mode` is true. One needs an ability to at times get the result of a blocking `nvim` function, such as many of `nvim` basic functions, e.g. `vim.fn.getcwd`. As such `snap` provides the ability to `yield` a function, have its execution run with `vim.schedule` and its resulting value returned.

```lua
local function producer(message)
  -- Yield a function to get its result
  local cwd = snap.sync(vim.fn.getcwd)
  -- Now we have the cwd we can do something with it
end
```

#### Yielding `nil`

Yielding nil signals to `snap` that there are not more results, and the coroutine is dead. `snap` will finish processing the `coroutine` when nil is encounted.

```lua
local function producer(message)
  coroutine.yield({"Result 1", "Result 1"})
  coroutine.yield(nil)
  -- Doesn't proces this, as coroutine is dead
  coroutine.yield({"Result 3", "Result 4"})
end
```

### Request

This is the request that is passed to a `producer`.

```typescript
type Request = {
  filter: string;
  winnr: number;
  canceled: () => boolean;
};
```

### ViewRequest

This is the request that is passed to view producers.

```typescript
type ViewRequest = {
  selection: string;
  bufnr: number;
  winnr: number;
  canceled: () => boolean;
};
```

### Producer

```typescript
type Producer = (request: Request) => yield<Yieldable>;
```

The full type of producer is actually:

```typescript
type ProducerWithDefault = {default: Producer} | Producer;
```

Because we support passing a table if it has a `default` field that is a producer. This enables producer modules to export a default producer, while also making orther related producers available, e.g. ones with additional configuration.

See: https://github.com/camspiers/snap/blob/main/fnl/snap/producer/ripgrep/file.fnl

### Consumer

```typescript
type Consumer = (producer: Producer) => Producer;
```

### ViewProducer

```typescript
type ViewProducer = (request: ViewRequest) => yield<function | nil>;
```

### `snap.run`

```typescript
{
  // Get the results to display
  producer: Producer;

  // Called on select
  select: (selection: string) => nil;

  // Optional prompt displayed to the user
  prompt?: string;

  // Optional function that enables multiselect
  multiselect?: (selections: table<string>) => nil;

  // Optional function configuring the results window
  layout?: () => {
    width: number;
    height: number;
    row: number;
    col: number;
  };

  // Optional initial filter
  initial_filter?: string;

  // Optional views
  views?: table<ViewProducer>
};
```

## Advanced API (for developers)

### `snap.meta_result`

Turns a result into a meta result.

```typescript
(result: string | MetaResult) => MetaResult
```

### `snap.with_meta`

Adds a meta field to a result.

```typescript
(result: string | MetaResult, field: string, value: any) => MetaResult
```

### `snap.has_meta`

Checks if a result has a meta field.

```typescript
(result: string | MetaResult, field: string) => boolean
```

### `snap.resume`

Resumes a passed coroutine while handling non-fast API requests.

TODO

### `snap.sync`

Yield a slow-mode function and get it's result.

```typescript
(fnc: () => T) => T
```

### `snap.consume`

Consumes a producer providing an iterator of its yielded results

```typescript
(producer: Producer, request: Request) => iterator<Yieldable>
```

### Layouts

#### `snap.layouts.centered`
#### `snap.layouts.bottom`
#### `snap.layouts.top`

### Producers

#### `snap.producer.vim.buffer`

Produces vim buffers.

#### `snap.producer.vim.oldfiles`

Produces vim oldfiles.

#### `snap.producer.luv.file`

Luv (`vim.loop`) based file producer.

```
NOTE: Requires no external dependencies.
```

#### `snap.producer.luv.directory`

Luv (`vim.loop`) based directory producer.

```
NOTE: Requires no external dependencies.
```

#### `snap.producer.ripgrep.file`

Ripgrep based file producer.

#### `snap.producer.ripgrep.vimgrep`

Ripgrep based grep producer in `vimgrep` format.

#### `snap.producer.fd.file`

Fd based file producer.

#### `snap.producer.fd.directory`

Fd based directory producer.

#### `snap.producer.git.file`

Git file producer.

### Consumers

#### `snap.consumer.cache`

General cache for producers whose values don't change in response to `request`.

#### `snap.consumer.limit`

General limit, will stop consuming a producer when a specified limit is reached.

#### `snap.consumer.fzy`

The workhorse consume for filtering producers that don't themselves filter.

NOTE: Requests `fzy`, e.g. `use_rocks 'fzy'`

#### `snap.consumer.fzy.filter`

A component piece of fzy that only filters.

#### `snap.consumer.fzy.score`

A component piece of fzy that only attaches score meta data.

#### `snap.consumer.fzy.positions`

A component piece of fzy that only attaches position meta data.

#### `snap.consumer.fzf`

Runs filtering through fzf, only supports basic positions highlighting for now.

#### `snap.consumer.try`

Accepts and arbitrary number of producers and upon the first that yields results then use it and skip the rest:

```lua
snap.get'consumer.try'(
  snap.get'producer.git.file',
  snap.get'producer.ripgrep.file'
)
```

#### `snap.consumer.combine`

Accepts and arbitrary number of producers and combines their results:

```lua
snap.get'consumer.combine'(
  snap.get'producer.ripgrep.file'.args({}, "/directory1"),
  snap.get'producer.ripgrep.file'.args({}, "/directory2"),
)
```

### Selectors

#### `snap.select.file`

Opens a file in a buffer in the last used window.

```
NOTE: Provides both `select` and `multiselect`.
```

#### `snap.select.vimgrep`

If a single file is selected then simply opens the file at appropriate position.

If multiple files are selected then it adds them to the quickfix list, and opens the first.

```
NOTE: Provides both `select` and `multiselect`.
```

#### `snap.select.cwd`

Changes directory in response to selection. 

#### `snap.select.insert`

Inserts selection at cursor location.

```
NOTE: Only provides `select`.
```

### Previewers

#### `snap.preview.file`

Creates a basic file previewer.

```
NOTE: Experimental, and relies on `file` program in path.
```

# Contributing

Snap is written in fennel, a language that compiles to Lua. See https://fennel-lang.org/

To install build dependencies:

```bash
make deps
```

To compile lua:

```bash
make compile
```

# Roadmap

- [x] Lua file producer
- [x] Preview system
- [x] More configurable layout system, including arbitrary windows
- [x] Configurable loading screen
- [x] FZF score/filter consumer
- [ ] More producers for vim concepts
- [ ] Lua filter consumer
- [ ] Tests

