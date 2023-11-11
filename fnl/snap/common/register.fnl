(module snap.common.register {require {tbl snap.common.tbl}})

;; Prefill with commands key
(local commands {})

(defn buf-map [bufnr modes keys fnc opts]
  "Creates a buffer mapping and creates callable signiture"
  (each [_ key (ipairs keys)]
    (each [_ mode (ipairs modes)]
      (vim.keymap.set mode key fnc (tbl.merge (or opts {:nowait true}) {:buffer bufnr})))))

(fn handle-string [tbl]
  "When a table is provided just return, if a string is provided wrap in the table"
  (match (type tbl)
    :table tbl
    :string [tbl]))

(defn map [modes keys fnc opts]
  "Creates a global mapping"
  (each [_ key (ipairs (handle-string keys))]
    (each [_ mode (ipairs (handle-string modes))]
      (vim.keymap.set mode key fnc (or opts {})))))

;; You should tend not to use this directly and instead just use snap.map with a command name
(defn command [name fnc]
  "Adds a named function to the global :Snap command"
  ;; When the Snap command isn't registered add it
  (when
    (= (length commands) 0)
    (vim.api.nvim_create_user_command
      :Snap
      (fn [opts]
        (local name (. opts.fargs 1))
        (when (?. commands name)
          ((. commands name))))
      {:nargs 1
       :complete (fn [] (vim.tbl_keys commands))}))

  (tset commands name fnc))
