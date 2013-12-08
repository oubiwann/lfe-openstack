(defmodule lferax-servers
  (export all))


(defun get-name-id (json-data)
  "Given some JSON data, parse just 'name' and 'id' attributes."
  (tuple
    (tuple (: ej get #("name") json-data))
    (tuple (: ej get #("id") json-data))))

(defun get-flavors-data (base-url region auth-token)
  (: lferax-util get-json-body
    (: lferax-http get
       (++ base-url '"/flavors/detail")
       region
       auth-token)))

(defun get-flavors-list (identity-response region auth-token)
  (let* ((base-url (: lferax-services get-cloud-servers-v2-url
                      identity-response
                      region)))
    (: lists map
       #'get-name-id/1
       (: ej get
          #("flavors")
          (get-flavors-data base-url region auth-token)))))

(defun get-server-list (identity-response region auth-token)
  (let ((base-url (: lferax-services get-cloud-servers-v2-url
                     identity-response
                     region)))
    (: lferax-http get
      (++ base-url '"/servers/detail")
      region auth-token)))

