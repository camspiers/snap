(let [snap (require :snap)
      tbl (snap.get :common.tbl)
      read-file (snap.get :preview.read-file)]
  (fn []
    (local tags-set {})
    (local tag-files (snap.sync (partial vim.fn.globpath vim.o.runtimepath "doc/tags" 1 1)))
    (each [_ tag-file (ipairs tag-files)]
      (local tags [])
      (local contents (read-file tag-file))
      (each [_ line (ipairs contents)]
        (when (not (line:match :^!_TAG_))
          (local [name] (vim.split line (string.char 9) true))
          (when (not (. tags-set name))
            (tset tags-set name true)
            (table.insert tags name))))
      (coroutine.yield tags))))

