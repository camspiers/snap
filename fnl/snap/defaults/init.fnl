(module snap.defaults {require {snap snap
                                tbl snap.common.tbl}
                       require-macros [snap.macros]})

(fn create-prompt [suffix prompt]
  (string.format "%s%s" prompt (or suffix :>)))

(fn with [fnc defaults]
  "Returns a new default with config pre-applied.

  If for example you prefer fzy over fzf, that is you don't like the common default, then:

  -- This creates a version of snap.defaults.file with fzy set as the default consumer:
  local file = defaults.file:with {consumer = 'fzy'}

  -- Adds a mapping to search buffers
  snap.map('n', '<Leader>b', file {producer = 'vim.buffer'})
"
  (fn [config]
    (fnc (tbl.merge defaults config))))

(fn file-producer-by-kind [config kind]
  "Gets a producer from producer type strings and handle special configs like args and hidden"
  (var producer (match kind
    :ripgrep.file (snap.get :producer.ripgrep.file)
    :fd.file (snap.get :producer.fd.file)
    :vim.oldfile (snap.get :producer.vim.oldfile)
    :vim.buffer (snap.get :producer.vim.buffer)
    :git.file (snap.get :producer.git.file)
    (where p (= (type p) :function)) p
    _ (assert false "file.producer is invalid")))

  ;; For ripgrep.file and fd.file set custom args or hidden
  (when
    (or (= kind :ripgrep.file) (= kind :fd.file))
    (if
      config.args
      (set producer (producer.args config.args))
      config.hidden
      (set producer producer.hidden)))

  producer)

(fn file-prompt-by-kind [type]
  (match type
    :ripgrep.file "Rg Files"
    :fd.file "Fd Files"
    :vim.oldfile "Old Files"
    :vim.buffer "Buffers"
    :git.file "Git Files"
    _ "Custom Files"))

(defmetafn file {: with} [config]
  "Returns a functon which runs `snap.run` for searching files with common file producers and common consumers.

  Supported producers:

  - ripgrep.file
  - fd.file
  - vim.oldfile
  - vim.buffer
  - git.file
  - any producer function that returns files

  Supported consumers:

  - fzf
  - fzy

  Additional options:

  - hidden
  - args
  - layout
  - prompt
  - suffix

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

  -- Runs with git.file producer with ripgrep.file fallback
  defaults.file {try = {'git.file', 'ripgrep.file}}

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
  (asserttable? config.try "file.try must be a table")
  (asserttable? config.combine "file.combine must be a table")

  ;; Ensure at least one producer config is set
  (assert (or config.producer config.try config.combine) "one of file.producer, file.try or file.combine must be set")A

  ;; Validate incompatible options
  (assert (not (and config.producer config.try)) "file.try and file.producer can not be used together")
  (assert (not (and config.producer config.combine)) "file.combine and file.producer can not be used together")
  (assert (not (and config.try config.combine)) "file.try and file.combine can not be used together")
  (assert (not (and config.hidden config.args)) "file.args and file.hidden can not be used together")

  ;; Helper function with config applied
  (local by-kind (partial file-producer-by-kind config))
  
  ;; Consumer kind
  (local consumer-kind (or config.consumer :fzf))

  ;; Get the initial producer module based on kind
  (local producer (if
    ;; If we are using try
    config.try
    ((snap.get :consumer.try) (unpack (vim.tbl_map by-kind config.try)))
    ;; If we are using combine
    config.combine
    ((snap.get :consumer.combine) (unpack (vim.tbl_map by-kind config.combine)))
    ;; Otherwise producer must be set
    (by-kind config.producer)))

  ;; Get the consumer module based on kind
  (local consumer (match consumer-kind
    :fzf (snap.get :consumer.fzf)
    :fzy (snap.get :consumer.fzy)
    (where c (= (type c) :function)) c
    _ (assert false "file.consumer is invalid")))

  ;; Defaults in the user defined suffix
  (local create-prompt (partial create-prompt config.suffix))

  ;; Create reasonable prompts based on kinds
  (local prompt (if
    config.prompt
    (create-prompt config.prompt)
    config.producer
    (create-prompt (file-prompt-by-kind config.producer))
    config.try
    (create-prompt (table.concat (vim.tbl_map file-prompt-by-kind config.try) " or "))
    config.combine
    (create-prompt (table.concat (vim.tbl_map file-prompt-by-kind config.combine) " + "))))

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

(fn vimgrep-prompt-by-kind [kind]
  (match kind
    :ripgrep.vimgrep "Rg Vimgrep"
    _ "Custom Vimgrep"))

(defmetafn vimgrep {: with} [config]
  (asserttable config)
  (assertstring? config.prompt "vimgrep.prompt must be a string")
  (assertnumber? config.limit "vimgrep.limit must be a number")
  (assertfunction? config.layout "vimgrep.layout must be a function")
  (asserttable? config.args "vimgrep.args must be a table")
  (assertboolean? config.hidden "vimgrep.hidden must be a boolean")

  ;; Get the producer type
  (local producer-kind (or config.producer :ripgrep.vimgrep))

  ;; Gets the producer based on the producer type
  (var producer (match producer-kind
    :ripgrep.vimgrep (snap.get :producer.ripgrep.vimgrep)
    (where p (= (type p) :function)) p
    _ (assert false "vimgrep.producer is invalid")))

  ;; Customize vimgrep
  (when
    (= producer-kind :ripgrep.vimgrep)
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

  ;; Defaults in the user defined suffix
  (local create-prompt (partial create-prompt config.suffix))

  ;; Get a reasonable default prompt based on kinds
  (local prompt (if
    config.prompt
    (create-prompt config.prompt)
    producer-kind
    (create-prompt (vimgrep-prompt-by-kind producer-kind))))

  ;; Get the select module
  (local select (snap.get :select.vimgrep))

  (fn [] (snap.run {: prompt
                    :layout (or config.layout nil)
                    :producer (consumer producer)
                    :select select.select
                    :multiselect select.multiselect
                    :views [(snap.get :preview.vimgrep)]})))

