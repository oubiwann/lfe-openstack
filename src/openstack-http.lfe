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

(defun post (url payload)
  (: lfe-rest-client-sync post url payload))

(defun post (url payload auth-token)
  (let* ((content-type '"application/json")
         (headers (get-auth-headers content-type auth-token))
         (request-data (tuple url headers content-type payload)))
  (: lfe-rest-client sync-request 'post request-data)))

(defun get (url auth-token)
  (let* ((content-type '"application/json")
         (payload '"")
         (headers (get-auth-headers content-type auth-token))
         (request-data (tuple url headers)))
  (: lfe-rest-client sync-request 'get request-data)))
