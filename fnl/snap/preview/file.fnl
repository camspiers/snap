(let [snap (require :snap)
      snap-io (snap.get :io)]
  (fn [request]
    (local path (snap.sync (partial vim.fn.fnamemodify (tostring request.selection) ":p")))
    (local handle (io.popen (string.format "file -n -b --mime-encoding %s" path)))
    (local encoding (string.gsub (handle:read "*a") "^%s*(.-)%s*$" "%1") )
    (handle:close)

    ;; Wait for other processing
    (snap.continue)

    ;; Read the data only for non-binary files
    (local preview (if
      (= encoding :binary)
      ["Binary file"]
      (do
        (var databuffer "")
        (local reader (coroutine.create snap-io.read))
        (while (not= (coroutine.status reader) :dead)
          (local (_ cancel data) (coroutine.resume reader path))
          (when (not= data nil) (set databuffer (.. databuffer data)))
          ;; yield to main thread and cancel if needed
          (snap.continue cancel))
        (vim.split databuffer "\n" true))))

    ;; Write the preview to the buffer.
    (snap.sync (fn []
      (when (not (request.canceled))
        ;; We don't need a cursorline
        (vim.api.nvim_win_set_option request.winnr :cursorline false)
        (vim.api.nvim_win_set_option request.winnr :cursorcolumn false)
        ;; Set the preview
        (vim.api.nvim_buf_set_lines request.bufnr 0 -1 false preview)
        ;; In case it's accidently saved
        (local fake-path (.. (vim.fn.tempname) "%" (vim.fn.fnamemodify (tostring request.selection) ":p:gs?/?%?")))
        ;; Use the fake path to enable ftdetection
        (vim.api.nvim_buf_set_name request.bufnr fake-path)
        ;; Detect the file type
        (vim.api.nvim_buf_call request.bufnr (partial vim.api.nvim_command "filetype detect")))))))
