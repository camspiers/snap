(let [snap (require :snap)]
  (fn [request]
    (local path (snap.sync (partial vim.fn.fnamemodify request.selection ":p")))
    (local handle (io.popen (string.format "file -n -b --mime-encoding %s" path)))
    (local encoding (string.gsub (handle:read "*a") "^%s*(.-)%s*$" "%1") )
    (if
      (= encoding :binary)
      ["Binary file"]
      (do
        (local fd (assert (vim.loop.fs_open path "r" 438)))
        (local stat (assert (vim.loop.fs_fstat fd)))
        (local data (assert (vim.loop.fs_read fd stat.size 0)))
        (assert (vim.loop.fs_close fd))
        (vim.split data "\n" true)))))

