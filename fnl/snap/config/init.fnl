(module snap.config {require {snap snap
                              tbl snap.common.tbl}
                     require-macros [snap.macros]})

;; Based off the concept that you should have at least 80 cols for preview and results (when all real estate is available)
(local default-min-width (* 80 2))

(fn preview-disabled [min-width]
  "Disables previews based on screen size"
  (<= (vim.api.nvim_get_option :columns) (or min-width default-min-width)))

(fn format-prompt [suffix prompt]
  "Formats a prompt"
  (string.format "%s%s" prompt (or suffix :>)))

(fn with [fnc defaults]
  "Returns a new default with config pre-applied.

  If for example you prefer fzy over fzf, then:

  -- This creates a version of snap.defaults.file with fzy set as the default consumer:
  local file = file:with {consumer = 'fzy'}

  -- Adds a mapping to search buffers
  snap.map('n', '<Leader>b', file {producer = 'vim.buffer'})"
  (fn [config] (fnc (tbl.merge defaults config))))

(fn file-producer-by-kind [config kind]
  "Gets a producer from producer type strings and handle special configs like args and hidden"
  (var producer (match kind
    :ripgrep.file (snap.get :producer.ripgrep.file)
    :fd.file      (snap.get :producer.fd.file)
    :vim.oldfile  (snap.get :producer.vim.oldfile)
    :vim.buffer   (snap.get :producer.vim.buffer)
    :git.file     (snap.get :producer.git.file)
    (where p (= (type p) :function)) p
    _ (assert false "file.producer is invalid")))
  ;; For ripgrep.file and fd.file set custom args or hidden
  (when
    (or (= kind :ripgrep.file)
        (= kind :fd.file))
    (if
      config.args
      (set producer (producer.args config.args))
      config.hidden
      (set producer producer.hidden)))
  producer)

(fn file-prompt-by-kind [kind]
  (match kind
    :ripgrep.file "Rg Files"
    :fd.file      "Fd Files"
    :vim.oldfile  "Old Files"
    :vim.buffer   "Buffers"
    :git.file     "Git Files"
    _             "Custom Files"))

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
  file {}

  -- Runs with fzy consumer
  file {consumer = 'fzy'}

  -- Runs with vim.oldfile producer
  file {producer = 'vim.oldfile'}

  -- Runs with vim.buffer producer
  file {producer = 'vim.buffer'}

  -- Runs with git.file producer
  file {producer = 'git.file'}

  -- Runs with git.file producer with ripgrep.file fallback
  file {try = {'git.file', 'ripgrep.file}}

  -- Customizes prompt
  file {prompt = 'My Prompt'}

  -- Customizes prompt suffix
  file {suffix = '>>'}

  -- When using propducer = 'ripgrep.file' sets the hidden flag
  file {hidden = true}

  -- When using propducer = 'ripgrep.file' customizes the arguments
  file {args = {'--hidden', '--iglob', '!.git/*'}}

  -- Provides a custom layout function
  file {layout = myCustomLayoutFunction}"

  (asserttable     config)
  (assertstring?   config.prompt            "file.prompt must be a string")
  (assertstring?   config.suffix            "file.suffix must be a string")
  (assertfunction? config.layout            "file.layout must be a function")
  (asserttable?    config.args              "file.args must be a table")
  (assertboolean?  config.hidden            "file.hidden must be a boolean")
  (asserttable?    config.try               "file.try must be a table")
  (asserttable?    config.combine           "file.combine must be a table")
  (assertboolean?  config.reverse           "file.reverse must be a boolean")
  (assertnumber?   config.preview-min-width "file.preview-min-with must be a boolean")
  (asserttypes?    [:function :boolean] config.preview "file.preview must be a boolean or a function")

  ;; Ensure at least one producer config is set
  (assert (or config.producer config.try config.combine) "one of file.producer, file.try or file.combine must be set")

  ;; Validate incompatible options
  (assert (not (and config.producer config.try))     "file.try and file.producer can not be used together")
  (assert (not (and config.producer config.combine)) "file.combine and file.producer can not be used together")
  (assert (not (and config.try      config.combine)) "file.try and file.combine can not be used together")
  (assert (not (and config.hidden   config.args))    "file.args and file.hidden can not be used together")

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
  (local add-prompt-suffix (partial format-prompt config.suffix))

  ;; Create reasonable prompts based on kinds
  (local prompt (add-prompt-suffix (if
    config.prompt
    config.prompt
    config.producer
    (file-prompt-by-kind config.producer)
    config.try
    (table.concat (vim.tbl_map file-prompt-by-kind config.try) " or ")
    config.combine
    (table.concat (vim.tbl_map file-prompt-by-kind config.combine) " + "))))

  ;; Get the selection module
  (local select-file (snap.get :select.file))

  ;; Define a function that handles the following:
  ;; if config.preview is nil or is true
  ;; then determinw if preview is disabled based on screen size
  ;; if config.preview is set and is false
  ;; then always hide
  ;; if config.preview is a function call the function and return the negation of the result
  (fn hide-views []
    (match (type config.preview)
      :nil (preview-disabled config.preview-min-width)
      :boolean (or (= config.preview false) (preview-disabled config.preview-min-width))
      :function (not (config.preview))))

  ;; Create a function to invoke snap
  (fn []
    (let [reverse (or config.reverse false)
          layout  (or config.layout nil)
          producer (consumer producer)
          select select-file.select
          multiselect select-file.multiselect
          views [(snap.get :preview.file)]]
      (snap.run {: prompt
                 : layout
                 : reverse
                 : producer
                 : select
                 : multiselect
                 : views
                 : hide-views}))))

(fn vimgrep-prompt-by-kind [kind]
  (match kind
    :ripgrep.vimgrep "Rg Vimgrep"
    _                "Custom Vimgrep"))

(defmetafn vimgrep {: with} [config]
  "Returns a functon which runs `snap.run` for grepping files.

  Supported producers:

  - ripgrep.vimgrep
  - any producer function that returns results in the vimgrep format

  Additional options:

  - hidden
  - args
  - layout
  - prompt
  - suffix
  - limit

  Examples:

  -- Runs with basic defaults, fzf and ripgrep.file
  vimgrep {}

  -- Customizes prompt
  vimgrep {prompt = 'My Prompt'}

  -- Customizes prompt suffix
  vimgrep {suffix = '>>'}

  -- When using propducer = 'ripgrep.vimgrep' sets the hidden flag
  vimgrep {hidden = true}

  -- When using propducer = 'ripgrep.vimgrep' customizes the arguments
  vimgrep {args = {'--hidden', '--iglob', '!.git/*'}}

  -- Provides a custom layout function
  vimgrep {layout = myCustomLayoutFunction}"

  (asserttable config)
  (assertstring?   config.prompt  "vimgrep.prompt must be a string")
  (assertnumber?   config.limit   "vimgrep.limit must be a number")
  (assertfunction? config.layout  "vimgrep.layout must be a function")
  (asserttable?    config.args    "vimgrep.args must be a table")
  (assertboolean?  config.hidden  "vimgrep.hidden must be a boolean")
  (assertstring?   config.suffix  "vimgrep.suffix must be a string")
  (assertboolean?  config.reverse "vimgrep.reverse must be a boolean")
  (assertboolean?  config.preview "vimgrep.preview must be a boolean")

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
  (local consumer (if
    config.limit
    (partial (snap.get :consumer.limit) config.limit)
    (fn [producer] producer)))

  ;; Defaults in the user defined suffix
  (local format-prompt (partial format-prompt config.suffix))

  ;; Get a reasonable default prompt based on kinds
  (local prompt (format-prompt (if
    config.prompt
    config.prompt
    producer-kind
    (vimgrep-prompt-by-kind producer-kind))))

  (local vimgrep-select (snap.get :select.vimgrep))

  ;; Get the preview flag with default to true
  (local preview (if (not= config.preview nil) config.preview true)) 

  (fn []
    (let [reverse (or config.reverse false)
          layout (or config.layout nil)
          producer (consumer producer)
          select vimgrep-select.select
          multiselect vimgrep-select.multiselect
          views (if preview [(snap.get :preview.vimgrep)] nil)]
      (snap.run {: prompt : layout : producer : select : multiselect : views}))))

