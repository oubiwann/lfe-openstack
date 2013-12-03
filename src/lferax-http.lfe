(defmodule lferax-http
  (export all))


(defun post (url payload)
  (: lferax-util start-services)
  (let* ((method 'post)
         (content-type '"application/json")
         (headers (list (tuple '"Content-Type" content-type)
                        (tuple '"User-Agent" (: lferax-const user-agent))))
         (request-data (tuple url headers content-type payload))
         (http-options ())
         (options ()))
  (: httpc request method request-data http-options options)))
