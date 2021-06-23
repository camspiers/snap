(module snap.defaults {require {snap snap
                                tbl snap.common.tbl}
                       require-macros [snap.macros]})

(defn with [type defaults]
  "Returns a new default with config pre-applied.

  If for example you prefer fzy over fzf, that is you don't like the common default, then:

  -- This creates a version of snap.defaults.file with fzy set as the default consumer:
  local file = defaults.with(defaults.file, {consumer = 'fzy'})

  -- Adds a mapping to search buffers
  snap.map('n', '<Leader>b', file({producer = 'vim.buffer'}))
"
  (fn [config]
    (type (tbl.merge defaults config))))

(defn file [config]
  "Returns a functon which runs `snap.run` for searching files with common file producers and common consumers.

  Supported producers:

  - ripgrep.file
  - vim.oldfile
  - vim.buffer
  - vim.help
  - git.file

  Supported consumers:

  - fzf
  - fzy

  Additional options:

  - hidden
  - args
  - layout
  - prompt

  Examples:

  -- Runs with basic defaults, fzf and ripgrep.file
  defaults.file {}

  -- Runs with fzy consumer
  defaults.file {consumer = 'fzy'}

  -- Runs with vim.oldfile producer
  defaults.file {producer = 'vim.oldfile'}

  -- Runs with vim.buffer producer
  defaults.file {producer = 'vim.buffer'}

  -- Runs with git.file producer
  defaults.file {producer = 'git.file'}

  -- Customizes prompt
  defaults.file {prompt = 'My Prompt>'}

  -- When using propducer = 'ripgrep.file' sets the hidden flag
  defaults.file {hidden = true}

  -- When using propducer = 'ripgrep.file' customizes the arguments
  defaults.file {args = {'--hidden', '--iglob', '!.git/*'}}

  -- Provides a custom layout function
  defaults.file {layout = myCustomLayoutFunction}"

  (asserttable config)
  (assertstring? config.prompt "file.prompt must be a string")
  (assertfunction? config.layout "file.layout must be a function")
  (asserttable? config.args "file.args must be a table")
  (assertboolean? config.hidden "file.hidden must be a boolean")

  ;; Get the producer type
  (local producer-type (or config.producer :ripgrep.file))
  
  ;; Consumer type
  (local consumer-type (or config.consumer :fzf))

  ;; Get the initial producer module based on type
  (var producer (match producer-type
    :ripgrep.file (snap.get :producer.ripgrep.file)
    :vim.oldfile (snap.get :producer.vim.oldfile)
    :vim.buffer (snap.get :producer.vim.buffer)
    :git.file (snap.get :producer.git.file)
    (where p (= (type p) :function)) p
    _ (assert false "file.producer is invalid")))

  ;; For ripgrep.file set custom args or hidden
  (when
    (= producer-type :ripgrep.file)
    (if
      config.args
      (set producer (producer.args config.args))
      config.hidden
      (set producer producer.hidden)))

  ;; Get the consumer module based on type
  (local consumer (match consumer-type
    :fzf (snap.get :consumer.fzf)
    :fzy (snap.get :consumer.fzy)
    (where c (= (type c) :function)) c
    _ (assert false "file.consumer is invalid")))

  ;; Create reasonable prompts based on types
  (local prompt (or config.prompt (match producer-type
    :ripgrep.file :Files>
    :vim.oldfile "Old Files>"
    :vim.buffer :Buffers>
    :git.file "Git Files>"
    _ "Files>")))

  ;; Get the select module
  (local select (snap.get :select.file))

  ;; Create a function to invoke snap
  (fn [] (snap.run {: prompt
                        :reverse (or config.reverse false)
                        :layout (or config.layout nil)
                        :producer (consumer producer)
                        :select select.select
                        :multiselect select.multiselect
                        :views [(snap.get :preview.file)]})))

(defn vimgrep [config]
  (asserttable config)
  (assertstring? config.prompt "vimgrep.prompt must be a string")
  (assertnumber? config.limit "vimgrep.limit must be a number")
  (assertfunction? config.layout "vimgrep.layout must be a function")
  (asserttable? config.args "vimgrep.args must be a table")
  (assertboolean? config.hidden "vimgrep.hidden must be a boolean")

  ;; Get the producer type
  (local producer-type (or config.producer :ripgrep.vimgrep))

  ;; Gets the producer based on the producer type
  (var producer (match producer-type
    :ripgrep.vimgrep (snap.get :producer.ripgrep.vimgrep)
    (where p (= (type p) :function)) p
    _ (assert false "vimgrep.producer is invalid")))

  ;; Customize vimgrep
  (when
    (= producer-type :ripgrep.vimgrep)
    (if
      config.args
      (set producer (producer.args config.args))
      config.hidden
      (set producer producer.hidden)))

  ;; Gets a consumer based on options like limit
  (local consumer
    (if
      config.limit
      (partial (snap.get :consumer.limit) config.limit)
      (fn [producer] producer)))

  ;; Get the select module
  (local select (snap.get :select.vimgrep))

  (fn [] (snap.run {:prompt (or config.prompt :Grep>)
                    :layout (or config.layout nil)
                    :producer (consumer producer)
                    :select select.select
                    :multiselect select.multiselect
                    :views [(snap.get :preview.vimgrep)]})))

