(defmodule openstack-http
  (export all))


(defun get-default-headers (content-type)
  (list (tuple (: openstack-const content-type)
               content-type)
        (tuple (: openstack-const user-agent)
               (: openstack-const user-agent-string))))

(defun get-auth-headers (content-type auth-token)
  (: lists merge (get-default-headers content-type)
                 (list (tuple (: openstack-const x-auth-token)
                              auth-token))))

(defun request (method request-data)
  (: openstack-util start-services)
  (let* ((http-options ())
         (options ()))
    (: httpc request method request-data http-options options)))

(defun post (url payload)
  (let* ((content-type '"application/json")
         (headers (get-default-headers content-type))
         (request-data (tuple url headers content-type payload)))
  (request 'post request-data)))

(defun post (url payload auth-token)
  (let* ((content-type '"application/json")
         (headers (get-auth-headers content-type auth-token))
         (request-data (tuple url headers content-type payload)))
  (request 'post request-data)))

(defun get (url auth-token)
  (let* ((content-type '"application/json")
         (payload '"")
         (headers (get-auth-headers content-type auth-token))
         (request-data (tuple url headers)))
  (request 'get request-data)))
