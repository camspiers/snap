(let [snap (require :snap)]
  (fn [types cwd]
    (local dirs [cwd])
    (local relative-dir (snap.sync (partial vim.fn.fnamemodify cwd ":.")))
    (while (> (length dirs) 0)
      (local dir (table.remove dirs))
      (local handle (vim.loop.fs_scandir dir))
      (local results [])
      (while handle
        (local (name t) (vim.loop.fs_scandir_next handle))
        (if name
          (do
            (local path (.. dir "/" name))
            (local relative-path (snap.sync (partial vim.fn.fnamemodify path ":.")))
            (when (. types t) (table.insert results relative-path))
            (when (= t :directory) (table.insert dirs path)))
          (lua "break")))
      (coroutine.yield results))))
