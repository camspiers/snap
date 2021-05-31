(let [snap (require :snap)
      snap-io (snap.get :io)
      parse (snap.get :common.vimgrep.parse)]

  (fn [request]
    (local selection (parse (tostring request.selection)))
    (local path (snap.sync (partial vim.fn.fnamemodify selection.filename ":p")))
    (local handle (io.popen (string.format "file -n -b --mime-encoding %s" path)))
    (local encoding (string.gsub (handle:read "*a") "^%s*(.-)%s*$" "%1") )
    (handle:close)

    ;; Allows other processes to run
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
          (when (request.canceled) (cancel) (coroutine.yield nil))
          ;; Need to continue in order to be able to read the file
          (snap.continue))
        (vim.split databuffer "\n" true))))

    ;; Write the preview to the buffer.
    (snap.sync (fn []
      (when (not (request.canceled))
        ;; Highlight using the cursor
        (vim.api.nvim_win_set_option request.winnr :cursorline true)
        (vim.api.nvim_win_set_option request.winnr :cursorcolumn true)
        ;; Set the preview
        (vim.api.nvim_buf_set_lines request.bufnr 0 -1 false preview)
        ;; In case it's accidently saved
        (local fake-path (.. (vim.fn.tempname) "%" (vim.fn.fnamemodify selection.filename ":p:gs?/?%?")))
        ;; Use the fake path to enable ftdetection
        (vim.api.nvim_buf_set_name request.bufnr fake-path)
        ;; Detect the file type
        (vim.api.nvim_buf_call request.bufnr (partial vim.api.nvim_command "filetype detect"))
        ;; Try to set cursor to appropriate line
        (when (not= encoding :binary)
          ;; TODO Col highlighting isn't working
          (vim.api.nvim_win_set_cursor request.winnr [selection.lnum (- selection.col 1)])))))))
