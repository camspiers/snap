# Snap

A fast finder system for neovim.

## Installation

### With Packer

```
use 'camspiers/snap.nvim'
```

If you want to use the inbuilt support for `fzy`:

```
use_rocks 'fzy'
```

## Basic example

The following is a basic example to give a taste of the API. It creates a highly performant live grep `snap`.

```lua
require'snap'.run {
  producer = require'snap.producer.ripgrep.vimgrep',
  select = require'snap.select.vimgrep'.select
  multiselect = require'snap.select.vimgrep'.multiselect
}
```

## Concepts

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
local io = require'snap.io'

-- Runs ls and yields lua tables containing each line
local function producer (request)
  -- Runs the slow-mode getcwd function
  local cwd = snap.sync(vim.fn.getcwd)
  -- Iterates ls commands output using snap.io.spawn
  for data, err, kill in io.spawn("ls", {}, cwd) do
    -- If the filter updates while the command is still running
    -- then we kill the process and yield nil
    if request.cancel then
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
require'snap'.run {
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
- Using the `request.cancel` signal to kill processes

## Usage

`snap` comes with inbuilt producers and consumers to enable easy creation of finders.

### Find Files

Uses built in `fzy` filter + score, and `ripgrep` for file finding.

```lua
require'snap'.run {
  producer = require'snap.consumer.fzy'(require'snap.producer.ripgrep.file'),
  select = require'snap.select.file'.select
  multiselect = require'snap.select.file'.multiselect
}
```

### Live Ripgrep

```lua
require'snap'.run {
  producer = require'snap.producer.ripgrep.vimgrep',
  select = require'snap.select.vimgrep'.select
  multiselect = require'snap.select.vimgrep'.multiselect
}
```

### Find Buffers

```lua
require'snap'.run {
  producer = require'snap.consumer.fzy'(require'snap.producer.buffer'),
  select = require'snap.select.file'.select
}
```

### Find Old Files

```lua
require'snap'.run {
  producer = require'snap.consumer.fzy'(require'snap.producer.oldfiles'),
  select = require'snap.select.file'.select
}
```

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
  cancel: boolean;
};
```

### Producer

```typescript
type Producer = (request: Request) => yield<Yieldable>;
```

### Consumer

```typescript
type Consumer = (producer: Producer) => Producer;
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
};
```

## Creating Mappings

`snap` registers no mappings, autocmds, or commands, and never will.

You can register your mappings in the following way:

```lua
local snap = require'snap'
snap.register.map({"n"}, {"<Leader>f"}, function ()
  snap.run {
    producer = require'snap.consumer.fzy'(require'snap.producer.ripgrep.file'),
    select = require'snap.select.file'.select
    multiselect = require'snap.select.file'.multiselect
  }
end)
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

```
(value: () => T) => T
```

### `snap.consume`

Consumes a producer providing an iterator of its yielded results

```
(producer: Producer, request: Request) => iterator<Yieldable>
```

### Layouts

#### `snap.layouts.centered`
#### `snap.layouts.bottom`
#### `snap.layouts.top`

### Producers

#### `snap.producer.buffer`

#### `snap.producer.oldfiles`

#### `snap.producer.ripgrep.file`

#### `snap.producer.ripgrep.vimgrep`

#### `snap.producer.fd.file`

#### `snap.producer.fd.directory`

### Consumers

#### `snap.consumer.cache`

#### `snap.consumer.fzy`

#### `snap.consumer.fzy.filter`

#### `snap.consumer.fzy.score`

### Selectors

#### `snap.select.file`

#### `snap.select.vimgrep`

#### `snap.select.cwd`

# Roadmap

- More producers
- FZF score/filter consumer
- Lua file producer
- Lua filter consumer
- More configurable layout system, including arbitrary windows
- Preview system
- Tests
- Configurable loading screens

