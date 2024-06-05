(module snap.common.io {require {snap snap}})

(defn system [cmd args cwd on-value on-error]
  (fn on-exit [result]
    (if
      (= result.code 0)
      (on-value result.stdout)
      (on-error result.stderr)))
  (vim.system [cmd (unpack args)] {: cwd} on-exit))

(defn spawn [cmd args cwd stdin]
  "Spawns a command and returns a command iterator"
  (var stdoutbuffer "")
  (var stderrbuffer "")
  (let [stdout (vim.loop.new_pipe false)
        stderr (vim.loop.new_pipe false)
        handle (vim.loop.spawn cmd {: args :stdio [stdin stdout stderr] : cwd}
                               (fn [code signal]
                                 (stdout:read_stop)
                                 (stderr:read_stop)
                                 (stdout:close)
                                 (stderr:close)
                                 (when stdin
                                   (stdin:read_stop)
                                   (stdin:close))
                                 (handle:close)))]
    (stdout:read_start (fn [err data]
                         (assert (not err))
                         (when data
                           (set stdoutbuffer (.. stdoutbuffer data)))))
    (stderr:read_start (fn [err data]
                         (assert (not err))
                         (when data
                           (set stderrbuffer (.. stderrbuffer data)))))

    (fn kill []
      (handle:kill vim.loop.constants.SIGTERM))

    (fn []
      (if
        (or (and handle (handle:is_active)) (not= stdoutbuffer ""))
        (let [stdout stdoutbuffer
              stderr stderrbuffer]
          (set stdoutbuffer "")
          (set stderrbuffer "")
          (values stdout stderr kill))
        nil))))

(defn exists [path]
  "Check if file exists"
  (local fd (vim.loop.fs_open path "r" 438))
  (when (~= fd nil) (vim.loop.fs_close fd))
  (~= fd nil))

(defn size [path]
  (local fd (vim.loop.fs_open path "r" 438))
  (local stat (vim.loop.fs_fstat fd))
  (vim.loop.fs_close fd)
  stat.size)

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
