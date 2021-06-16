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

(fn asserttype [typ value msg]
  `(assert (= (type ,value) ,typ) ,msg))

(fn asserttype? [typ value msg]
  `(when ,value (asserttype ,typ ,value ,msg)))

(fn assertfunction [value msg]
  `(asserttype :function ,value ,msg))

(fn assertfunction? [value msg]
  `(asserttype? :function ,value ,msg))

(fn asserttable [value msg]
  `(asserttype :table ,value ,msg))

(fn asserttable? [value msg]
  `(asserttype? :table ,value ,msg))

(fn assertstring [value msg]
  `(asserttype :string ,value ,msg))

(fn assertstring? [value msg]
  `(asserttype? :string ,value ,msg))

(fn assertthread [value msg]
  `(asserttype :thread ,value ,msg))

(fn assertthread? [value msg]
  `(asserttype? :thread ,value ,msg))

(fn assertboolean [value msg]
  `(asserttype :boolean ,value ,msg))

(fn assertboolean? [value msg]
  `(asserttype? :boolean ,value ,msg))

(fn assertmetatable [value metatable msg]
  `(assert (= (getmetatable ,value) ,metatable) ,msg))

{: safefn
 : safecall
 : safedebounced
 : asserttype
 : asserttype?
 : assertfunction
 : assertfunction?
 : asserttable
 : asserttable?
 : assertstring
 : assertstring?
 : assertthread
 : assertthread?
 : assertboolean
 : assertboolean?
 : assertmetatable}
