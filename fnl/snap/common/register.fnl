(module snap.common.register)

(local register {})

(defn clean [group]
  "Cleans up unneeded buffer maps"
  (tset register group nil))

(defn run [group fnc]
  "Provides ability to run fn"
  (when (?. register group fnc)
    ((. register group fnc))))

(defn get-by-template [group fnc pre post]
  (let [group-fns (or (. register group) [])
        id (string.format "%s" fnc)]
    (tset register group group-fns)
    (when (= (. group-fns id) nil)
      (tset group-fns id fnc))
    (string.format "%slua require'snap'.register.run('%s', '%s')%s" pre group id post)))

(defn get-map-call [group fnc]
  "Generates call signiture for maps"
  (get-by-template group fnc :<Cmd> :<CR>))

(defn get-autocmd-call [group fnc]
  "Generates call signiture for autocmds"
  (get-by-template group fnc ":" ""))

(defn buf-map [bufnr modes keys fnc opts]
  "Creates a buffer mapping and creates callable signiture"
  (let [rhs (get-map-call (tostring bufnr) fnc)]
    (each [_ key (ipairs keys)]
      (each [_ mode (ipairs modes)]
        (vim.api.nvim_buf_set_keymap bufnr mode key rhs (or opts {:nowait true}))))))

(fn handle-string [tbl]
  "When a table is provided just return, if a string is provided wrap in the table"
  (match (type tbl)
    :table tbl
    :string [tbl]))

(defn map [modes keys fnc opts]
  "Creates a global mapping"
  (let [rhs (get-map-call "global" fnc)]
    (each [_ key (ipairs (handle-string keys))]
      (each [_ mode (ipairs (handle-string modes))]
        (vim.api.nvim_set_keymap mode key rhs (or opts {}))))))
