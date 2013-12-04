(defmodule lferax-identity
  (export all)
  (import
    (from lferax-util
          (json-wrap 1)
          (json-wrap 2))))


(defun build-creds
  "Jiffy doesn't handle strings well for JSON, though it does handle binaries
  well. As such, all strings should be converted to binary before being passed
  to Jiffy."
  ((username 'password password)
   (json-wrap
     (tuple 'passwordCredentials
       (json-wrap (tuple 'username (: erlang list_to_binary username))
                  (tuple 'password (: erlang list_to_binary password))))))
  ((username 'apikey apikey)
   (json-wrap
     (tuple 'RAX-KSKEY:apiKeyCredentials
       (json-wrap (tuple 'username (: erlang list_to_binary username))
                  (tuple 'apiKey (: erlang list_to_binary apikey)))))))

(defun get-password-auth-payload (username password)
  (binary_to_list
    (: jiffy encode
      (json-wrap (tuple 'auth (build-creds username 'password password))))))

(defun get-apikey-auth-payload (username apikey)
  (binary_to_list
    (: jiffy encode
      (json-wrap (tuple 'auth (build-creds username 'apikey apikey))))))

(defun get-auth-payload
  ((username 'apikey apikey) (get-apikey-auth-payload username apikey))
  ((username 'password password) (get-password-auth-payload username password)))

(defun password-login (username password)
  (: lferax-http post
    (: lferax-const auth-url)
    (get-auth-payload username 'password password)))

(defun apikey-login (username apikey)
  (: lferax-http post
    (: lferax-const auth-url)
    (get-auth-payload username 'apikey apikey)))

(defun login
  ((username 'apikey apikey) (apikey-login username apikey))
  ((username 'password password) (password-login username password)))

(defun get-disk-username ()
  (: lferax-util read-file (: lferax-const username-file)))

(defun get-disk-password ()
  (: lferax-util read-file (: lferax-const password-file)))

(defun get-disk-apikey ()
  (: lferax-util read-file (: lferax-const apikey-file)))

(defun get-env-username ()
  (: os getenv (: lferax-const username-env)))

(defun get-env-password ()
  (: os getenv (: lferax-const password-env)))

(defun get-env-apikey ()
  (: os getenv (: lferax-const apikey-env)))

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

(defun login ()
  ""
  (login (get-username) 'apikey (get-apikey)))

(defun login (mode)
  ""
  (cond ((=:= mode 'apikey) (login))
        ('true (login (get-username) 'password (get-password)))))
