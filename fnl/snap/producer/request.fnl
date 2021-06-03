(module snap.producer.request)

(defn create [config]
  "Creates a producer request"
  ;; Config validation
  (assert (= (type config.body) :table) "body must be a table")
  (assert (= (type config.cancel) :function) "cancel must be a function")
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
