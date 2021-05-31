(let [snap (require :snap)
      snap-io (snap.get :io)]
  (fn [path]
    (local handle (io.popen (string.format "file -n -b --mime-encoding %s" path)))
    (local encoding (string.gsub (handle:read "*a") "^%s*(.-)%s*$" "%1") )
    (handle:close)
    (var preview nil)
    (if
      (= encoding :binary)
      (set preview ["Binary file"])
      (do
        (var databuffer "")
        (var reader (coroutine.create snap-io.read))
        (fn free [cancel]
          (when cancel (cancel))
          (set databuffer "")
          (set reader nil))
        (while (not= (coroutine.status reader) :dead)
          (local (_ cancel data) (coroutine.resume reader path))
          (when (not= data nil) (set databuffer (.. databuffer data)))
          ;; yield to main thread and cancel if needed
          (snap.continue (partial free cancel)))
        (set preview (vim.split databuffer "\n" true))
        (free)))
    preview))
