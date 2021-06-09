;; Defines a function that will safe schedule non-fast code
(fn safefn [name ...]
  `(local ,name (vim.schedule_wrap (fn ,...))))

;; Calls a non-fast mode function safely
(fn safecall [fnc ...]
  `((vim.schedule_wrap ,fnc) ,...))

;; Defines a function that will safe schedule non-fast mode code
;; but when called again before the scheduled code is run,
;; it will just swap the arguments of the old call for the new call
(fn safedebounced [name ...]
  `(local ,name
     (do
       (local body# (fn ,...))
       (var args# nil)
       (fn [...]
         (if
           ;; when the args are nil we need to schedule
           (= args# nil)
           (do
             (set args# [...])
             (vim.schedule (fn []
               (let [actual-args# args#]
                 ;; we reached the call to clear
                 (set args# nil)
                 (body# (unpack actual-args#))))))
           ;; When the args are already set we have already scheduled
           ;; so just swap the args to be called with
           (set args# [...]))))))

(fn assertfunction [value msg]
  `(assert (= (type ,value) :function) ,msg))

(fn assertfunction? [value msg]
  `(when ,value (assertfunction ,value ,msg)))

(fn asserttable [value msg]
  `(assert (= (type ,value) :table) ,msg))

(fn asserttable? [value msg]
  `(when ,value (asserttable ,value ,msg)))

(fn assertstring [value msg]
  `(assert (= (type ,value) :string) ,msg))

(fn assertstring? [value msg]
  `(when ,value (assertstring ,value ,msg)))

(fn assertmetatable [value metatable msg]
  `(assert (= (getmetatable ,value) metatable) ,msg))

(fn assertthread [value msg]
  `(assert (= (type ,value) :thread) ,msg))

{: safefn
 : safecall
 : safedebounced
 : assertfunction
 : assertfunction?
 : asserttable
 : asserttable?
 : assertstring
 : assertstring?
 : assertmetatable
 : assertthread}
