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
                                'password password)))))
  ((username 'apikey apikey)
   (json-wrap
     (list 'RAX-KSKEY:apiKeyCredentials
           (json-wrap-bin (list 'username username
                                'apiKey apikey))))))

(defun get-password-auth-payload (username password)
  (binary_to_list
    (: jiffy encode
      (json-wrap (list 'auth (build-creds username 'password password))))))

(defun get-apikey-auth-payload (username apikey)
  (binary_to_list
    (: jiffy encode
      (json-wrap (list 'auth (build-creds username 'apikey apikey))))))

(defun get-auth-payload
  ((username 'apikey apikey) (get-apikey-auth-payload username apikey))
  ((username 'password password) (get-password-auth-payload username password)))

(defun password-login (username password)
  (: openstack-http post
    (: openstack-const auth-url)
    (get-auth-payload username 'password password)))

(defun apikey-login (username apikey)
  (: openstack-http post
    (: openstack-const auth-url)
    (get-auth-payload username 'apikey apikey)))

(defun get-disk-username ()
  (: openstack-util read-file (: openstack-const username-file)))

(defun get-disk-password ()
  (: openstack-util read-file (: openstack-const password-file)))

(defun get-disk-apikey ()
  (: openstack-util read-file (: openstack-const apikey-file)))

(defun get-env-username ()
  (: os getenv (: openstack-const username-env)))

(defun get-env-password ()
  (: os getenv (: openstack-const password-env)))

(defun get-env-apikey ()
  (: os getenv (: openstack-const apikey-env)))

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

(defun get-apikey ()
  (let ((apikey (get-env-apikey)))
    (cond ((not (=:= apikey 'false))
           apikey)
          ('true (get-disk-apikey)))))

(defun get-apikey-or-password ()
  (let ((apikey (get-apikey)))
    (cond ((not (=:= apikey ""))
           apikey)
          ('true (get-password)))))

(defun login
  ((username 'apikey apikey) (apikey-login username apikey))
  ((username 'password password) (password-login username password)))

(defun login ()
  ""
  (login (get-username) 'apikey (get-apikey)))

(defun login (mode)
  ""
  (cond ((=:= mode 'apikey) (login))
        ('true (login (get-username) 'password (get-password)))))

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




