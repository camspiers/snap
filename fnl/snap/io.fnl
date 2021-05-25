(module snap.io {require {snap snap}})

;; fnlfmt: skip
(defn spawn [cmd args cwd]
  (var stdinbuffer "")
  (var stderrbuffer "")
  (let [stdout (vim.loop.new_pipe false)
        stderr (vim.loop.new_pipe false)
        handle (vim.loop.spawn cmd {: args :stdio [nil stdout stderr] : cwd}
                               (fn [code signal]
                                 (stdout:read_stop)
                                 (stderr:read_stop)
                                 (stdout:close)
                                 (stderr:close)
                                 (handle:close)))]
    (stdout:read_start (fn [err data]
                         (assert (not err))
                         (when data
                           (set stdinbuffer data))))
    (stderr:read_start (fn [err data]
                         (assert (not err))
                         (when data
                           (set stderrbuffer data))))

    (fn kill []
      (handle:kill vim.loop.constants.SIGTERM))

    (fn iterator []
      (if (and handle (handle:is_active))
          (let [stdin stdinbuffer
                stderr stderrbuffer]
            (set stdinbuffer "")
            (set stderrbuffer "")
            (values stdin stderr kill))
          nil))

    iterator))


