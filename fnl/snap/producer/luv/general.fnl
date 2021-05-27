(fn [types cwd]
  (local dirs [cwd])
  (while (> (length dirs) 0)
    (local dir (table.remove dirs))
    (local handle (vim.loop.fs_scandir dir))
    (local results [])
    (while handle
      (local (name t) (vim.loop.fs_scandir_next handle))
      (if name
        (do
          (local path (.. dir "/" name))
          (when (. types t) (table.insert results path))
          (when (= t :directory) (table.insert dirs path)))
        (lua "break")))
    (coroutine.yield results)))
