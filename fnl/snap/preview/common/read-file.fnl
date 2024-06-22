(let [snap (require :snap)
      snap-io (snap.get :common.io)]
  (fn get-encoding [path]
    (local handle (io.popen (string.format "file -n -b --mime-encoding '%s'" path)))
    (local encoding (string.gsub (handle:read "*a") "^%s*(.-)%s*$" "%1") )
    (handle:close)
    encoding)

  ;; Make file size for preview
  (local max-size (* 1024 500))

  (fn [path on-resume]
    (var preview nil)
    (if
      (not (snap-io.exists path))
      (set preview ["File does not exist"])
      (= (get-encoding path) :binary)
      (set preview ["Binary file"])
      (> (snap-io.size path) max-size)
      (set preview ["File too large to preview"])
      (do
        (var databuffer "")
        (var reader (coroutine.create snap-io.read))
        (fn free [cancel]
          (when cancel (cancel))
          (set databuffer "")
          (set reader nil))
        (while (not= (coroutine.status reader) :dead)
          (when on-resume (on-resume))
          (local (_ cancel data) (coroutine.resume reader path))
          (when
            (not= data nil)
            (set databuffer (.. databuffer data)))
          ;; yield to main thread and cancel if needed
          (snap.continue (partial free cancel)))
        (set preview [])
        (each [line (databuffer:gmatch "([^\r\n]*)[\r\n]?")]
          (table.insert preview line))
        (free)))
    preview))
