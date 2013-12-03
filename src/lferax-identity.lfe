(defmodule lferax-identity
  (export all))


(defun password-auth-payload (username password)
  'true)

(defun apikey-auth-payload (username apikey)
  'true)

(defun get-auth-payload
  ((username 'apikey apikey) (apikey-auth-payload username apikey))
  ((username 'password password) (password-auth-payload username password)))

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
