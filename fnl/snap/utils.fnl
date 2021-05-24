(module snap.utils)

;; Runs a command and waits for output

;; fnlfmt: skip
(defn run [cmd]
  (with-open [file (io.popen cmd :r)]
    (let [contents (file:read :*all)]
      (vim.tbl_filter #(not= $1 "") (vim.split contents "\n")))))

