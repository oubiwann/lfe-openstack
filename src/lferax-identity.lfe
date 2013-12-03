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
                  (tuple 'apikey (: erlang list_to_binary apikey)))))))

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


