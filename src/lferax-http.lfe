(defmodule lferax-http
  (export all))


(defun get-default-headers (content-type)
  (list (tuple (: lferax-const content-type)
               content-type)
        (tuple (: lferax-const user-agent)
               (: lferax-const user-agent-string))))

(defun get-auth-headers (content-type auth-token)
  (: lists merge (get-default-headers content-type)
                 (list (tuple (: lferax-const x-auth-token)
                              auth-token))))

; XXX all of these need to be refactored to reduce boilerplate
(defun post (url payload)
  (: lferax-util start-services)
  (let* ((method 'post)
         (content-type '"application/json")
         (headers (get-default-headers content-type))
         (request-data (tuple url headers content-type payload))
         (http-options ())
         (options ()))
  (: httpc request method request-data http-options options)))

(defun post (url payload auth-token)
  (: lferax-util start-services)
  (let* ((method 'post)
         (content-type '"application/json")
         (headers (get-auth-headers content-type auth-token))
         (request-data (tuple url headers content-type payload))
         (http-options ())
         (options ()))
  (: httpc request method request-data http-options options)))

(defun get (url region auth-token)
  (: lferax-util start-services)
  (let* ((method 'get)
         (content-type '"application/json")
         (payload '"")
         (headers (get-auth-headers content-type auth-token))
         (request-data (tuple url headers))
         (http-options ())
         (options ()))
  (: httpc request method request-data http-options options)))

