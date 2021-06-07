(module snap.producer.create {require {snap snap}})

(fn create-slow-api []
  "Creates an api for handling slow values"
  (local slow-api {:pending false :value nil})
  (fn slow-api.schedule [fnc]
    (tset slow-api :pending true)
    (vim.schedule (fn []
      (tset slow-api :value (fnc))
      (tset slow-api :pending false))))
  slow-api)

(fn [{: producer
      : request
      : on-end
      : on-value
      : on-tick}]
  "Schedules a view for generation"
  ;; By the time the routine runs, we might be able to avoid it
  (when (not (request.canceled))
    ;; Create the idle loop
    (var idle (vim.loop.new_idle))
    ;; Create the producer
    (var thread (coroutine.create producer))
    ;; Tracks the requests of slow nvim calls
    (var slow-api (create-slow-api))
    ;; Handle ending the idle loop and optionally calling on end
    (fn stop []
      (idle:stop)
      (set idle nil)
      (set thread nil)
      (set slow-api nil)
      (when on-end (on-end)))
    ;; This runs on each idle check
    (fn start []
      (if
        ;; Only run when we aren't waiting for a slow-api call
        slow-api.pending
        ;; Return nil
        nil
        ;; When the thread is not dead
        (not= (coroutine.status thread) :dead)
        ;; Run the resume
        (do
          ;; Fetches results be also sends cancel signal
          (let [(_ value on-cancel) (coroutine.resume thread request slow-api.value)]
            ;; Match each type
            (match (type value)
              ;; We have a function so schedule it to be computed
              :function (slow-api.schedule value)
              :nil (stop)
              (where :table (= value snap.continue_value))
                (if
                  (request.canceled)
                  (do
                    (when on-cancel (on-cancel))
                    (stop)))
              _ (when on-value (on-value value)))
          (when on-tick (on-tick))))
        ;; When the coroutine is dead then stop the loop
        (stop)))

    ;; Start the checker after each IO poll
    (idle:start start)))
