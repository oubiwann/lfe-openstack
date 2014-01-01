(defmodule openstack-identity
  (export all)
  (import
    (from openstack-util
          (json-wrap 1)
          (json-wrap-bin 1))))


(defun build-creds
  "Jiffy doesn't handle strings well for JSON, though it does handle binaries
  well. As such, all strings should be converted to binary before being passed
  to Jiffy."
  ((username 'password password)
   (json-wrap
     (list 'passwordCredentials
           (json-wrap-bin (list 'username username
                                'password password))))))

(defun get-password-auth-payload (username password)
  (binary_to_list
    (: jiffy encode
      (json-wrap (list 'auth (build-creds username 'password password))))))

(defun get-auth-payload
  ((username 'password password) (get-password-auth-payload username password)))

(defun authenticate (url username password)
  (: openstack-http post
    url (get-auth-payload username 'password password)))

(defun get-disk-username ()
  (: openstack-util read-file (: openstack-const username-file)))

(defun get-disk-password ()
  (: openstack-util read-file (: openstack-const password-file)))

(defun get-disk-auth-url ()
  (: openstack-util read-file (: openstack-const auth-url-file)))

(defun get-env-username ()
  (: os getenv (: openstack-const username-env)))

(defun get-env-password ()
  (: os getenv (: openstack-const password-env)))

(defun get-env-auth-url ()
  (: os getenv (: openstack-const auth-url-env)))

(defun get-username ()
  (let ((username (get-env-username)))
    (cond ((not (=:= username 'false))
           username)
          ('true (get-disk-username)))))

(defun get-password ()
  (let ((password (get-env-password)))
    (cond ((not (=:= password 'false))
           password)
          ('true (get-disk-password)))))

(defun get-auth-url ()
  (let ((auth-url (get-env-auth-url)))
    (cond ((not (=:= auth-url 'false))
           auth-url)
          ('true (get-disk-auth-url)))))

(defun login (url username password)
  (authenticate url username password))

(defun login (('provider provider)
  (let ((username (: openstack-config get-username provider))
        (password (: openstack-config get-password provider))
        (url (: openstack-config get-auth-url provider)))
    (login url username password))))

(defun login ()
  ""
  (login (get-auth-url) (get-username) (get-password)))

(defun get-token (identity-response)
  (binary_to_list
    (: ej get
       #("access" "token" "id")
       (: openstack-util get-json-body identity-response))))

(defun get-tenant-id (identity-response)
  (binary_to_list
    (: ej get
       #("access" "token" "tenant" "id")
       (: openstack-util get-json-body identity-response))))

(defun get-user-id (identity-response)
  (binary_to_list
    (: ej get
       #("access" "user" "id")
       (: openstack-util get-json-body identity-response))))

(defun get-user-name (identity-response)
  (binary_to_list
    (: ej get
       #("access" "user" "name")
       (: openstack-util get-json-body identity-response))))




