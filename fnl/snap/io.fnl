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
                           (set stdinbuffer (.. stdinbuffer data)))))
    (stderr:read_start (fn [err data]
                         (assert (not err))
                         (when data
                           (set stderrbuffer (.. stderrbuffer data)))))

    (fn kill []
      (handle:kill vim.loop.constants.SIGTERM))

    (fn []
      (if
        (and handle (handle:is_active))
        (let [stdin stdinbuffer
              stderr stderrbuffer]
          (set stdinbuffer "")
          (set stderrbuffer "")
          (values stdin stderr kill))
        nil))))

(local chunk-size 1000)

(defn read [path]
  (var closed false)
  (var canceled false)
  (var databuffer "")
  (var fd nil)
  (var stat nil)
  (var current-offset 0)

  (fn on-close [err]
    (assert (not err) err))

  (fn close []
    (set closed true)
    (vim.loop.fs_close fd on-close))

  (fn cancel []
    (set canceled true))

  (fn on-read [err data]
    (assert (not err) err)
    (set databuffer (.. databuffer data))
    (set current-offset (+ current-offset chunk-size))
    (when
      (not closed)
      (if
        (or canceled (>= current-offset stat.size))
        (close)
        (vim.loop.fs_read fd chunk-size current-offset on-read))))

  (fn on-stat [err s]
    (assert (not err) err)
    (set stat s)
    (vim.loop.fs_read fd (math.min chunk-size stat.size) current-offset on-read))

  (fn on-open [err f]
    (assert (not err) err)
    (set fd f)
    (vim.loop.fs_fstat fd on-stat))

  (local handle (vim.loop.fs_open path "r" 438 on-open))

  (while
    (or (not closed) (not= databuffer ""))
    (if
      (not= databuffer "")
      (do
        (local data databuffer)
        (set databuffer "")
        (coroutine.yield cancel data))
      (coroutine.yield cancel))))



