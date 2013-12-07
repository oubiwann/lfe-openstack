(defmodule lferax-servers
  (export all))


(defun get-flavors-list (identity-response region auth-token)
  (let* ((base-url (: lferax-services get-cloud-servers-v2-url
                      identity-response
                      region))
         (flavors-response (: lferax-http get (++ base-url '"/flavors/detail")
                                              region auth-token)))
    (: lists map
       (lambda (x)
         (tuple (tuple (: ej get #("name") x))
                (tuple (: ej get #("id") x))))
       (: ej get
          #("flavors")
          (: lferax-util get-json-body flavors-response)))))

(defun get-server-list (identity-response region auth-token)
  (let ((base-url (: lferax-services get-cloud-servers-v2-url
                     identity-response
                     region)))
    (: lferax-http get
      (++ base-url '"/servers/detail")
      region auth-token)))

