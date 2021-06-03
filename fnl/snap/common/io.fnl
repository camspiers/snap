(module snap.common.io {require {snap snap}})

(defn spawn [cmd args cwd]
  "Spawns a command and returns a command iterator"
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

(local chunk-size 10000)

(defn read [path]
  "Reads a file and yields contents"
  (var closed false)
  (var canceled false)
  (var reading true)
  (var databuffer "")
  (var fd nil)
  (var stat nil)
  (var current-offset 0)

  (fn on-close [err]
    (assert (not err) err)
    (set closed true))

  (fn on-read [err data]
    (assert (not err) err)
    (set databuffer data))

  (fn on-stat [err s]
    (assert (not err) err)
    (set stat s)
    (vim.loop.fs_read fd (math.min chunk-size stat.size) current-offset on-read))

  (fn on-open [err f]
    (assert (not err) err)
    (set fd f)
    (vim.loop.fs_fstat fd on-stat))

  (vim.loop.fs_open path "r" 438 on-open)

  (fn close [] (vim.loop.fs_close fd on-close))

  (fn cancel [] (set canceled true))

  (while
    (not closed)
    (if
      (or (not fd) (not stat) (= databuffer ""))
      (coroutine.yield cancel)
      (do
        (local data databuffer)
        (set databuffer "")
        (if
          canceled
          (close)
          reading
          (do
            (set current-offset (+ current-offset chunk-size))
            (if
              (< current-offset stat.size)
              (vim.loop.fs_read fd chunk-size current-offset on-read)
              (do
                (set reading false)
                (close)))))

        (coroutine.yield cancel data)))))
