(local snap (require :snap))
(local layout (require :snap.layout))
(local tbl (require :snap.common.tbl))
(local snap-string (require :snap.common.string))

(local filter (if (pcall require :fzy)
                (require :snap.consumer.fzy)
                (require :snap.consumer.fzf)))

(fn action-layout [actions]
  (let [columns (layout.columns)
        lines (layout.lines)
        max-length (tbl.max-length actions)
        width (* max-length 3)
        height (+ (length actions) 3)]
    {: width
     : height
     :col (layout.middle columns width)
     :row (layout.middle lines height)}))

(fn checkout [selection on-done]
  (vim.system
    [:git :checkout (tostring selection)]
    {:cwd (vim.fn.getcwd)}
    #(case $1.code
       0 (do
           (when on-done (vim.schedule on-done))
           (vim.notify
             (string.format "Checked out '%s'" (tostring selection))
             vim.log.levels.INFO))
       _ (vim.notify
           (string.format "Error when checking out '%s':\n%s" (tostring selection) $1.stderr)
           vim.log.levels.ERROR))))

(fn reset-soft [selection]
  (vim.system
    [:git :reset :--soft (tostring selection)]
    {:cwd (vim.fn.getcwd)}
    #(when
       (= $1.code 0)
       (vim.notify
         (string.format "Soft reset '%s'" (tostring selection))
         vim.log.levels.INFO))))

(fn reset-hard [selection]
  (vim.system
    [:git :reset :--hard (tostring selection)]
    {:cwd (vim.fn.getcwd)}
    #(when
       (= $1.code 0)
       (vim.notify
         (string.format "Hard reset '%s'" (tostring selection))
         vim.log.levels.INFO))))

(fn pull [branch remote]
  (checkout branch #(vim.system
    [:git :pull (tostring remote) (tostring branch)]
    {:cwd (vim.fn.getcwd)}
    #(when
       (= $1.code 0)
       (vim.notify
         (string.format "Pulled '%s/%s'" (tostring remote) (tostring branch))
         vim.log.levels.INFO)))))

(fn pull-list [branch]
  (vim.system
    [:git :remote]
    {:cwd (vim.fn.getcwd)}
    #(when
       (= $1.code 0)
       (local remotes (snap-string.split $1.stdout))
       (vim.schedule #(snap.run {:prompt :Select>
                  :producer (filter (fn [] remotes))
                  :select (partial (vim.schedule_wrap pull) branch)
                  :layout (partial action-layout remotes)})))))

(local branch-actions (vim.tbl_map #(snap.with_metas $1.label $1) [
  {:label "Checkout" :action checkout}
  {:label "Reset (soft)" :action reset-soft}
  {:label "Reset (hard)" :action reset-hard}
  {:label "Pull" :action pull-list}]))

(fn branch [selection]
  (snap.run {:prompt :Select>
             :producer (filter (fn [] branch-actions))
             :select #($1.action selection)
             :layout (partial action-layout branch-actions)}))

{: branch}
