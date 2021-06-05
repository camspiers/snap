(module snap.producer.request {require-macros [snap.macros]})

(defn create [config]
  "Creates a producer request"
  ;; Config validation
  (asserttable config.body "body must be a table")
  (assertfunction config.cancel "cancel must be a function")
  ;; Set up the request
  (local request {:is-canceled false})
  ;; Copy each value
  (each [key value (pairs config.body)]
    (tset request key value))
  ;; Cancels the request
  (fn request.cancel [] (tset request :is-canceled true))
  ;; Checkes if request is canceled
  (fn request.canceled [] (or request.is-canceled (config.cancel request)))
  request)
