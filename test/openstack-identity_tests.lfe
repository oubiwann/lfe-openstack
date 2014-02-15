(defmodule openstack-identity_tests
  (export all)
  (import
    (from lfeunit-util
          (check-failed-assert 2)
          (check-wrong-is-exception 2))
    (rename lfe-rest-client
            ((get-default-headers 1) get-headers))
    (from lfe-rest-client-util
          (get-body 1))))

(include-lib "deps/lfeunit/include/lfeunit-macros.lfe")

(deftest build-creds-password
  (let ((data (build-creds '"alice" 'password '"asecret"))
        (expected #((#(passwordCredentials
                        #((#(username #B(97 108 105 99 101))
                             #(password #B(97 115 101 99 114 101 116)))))))))
    (is-equal expected data)))

; XXX this unit test is currently broken
(deftest get-password-auth-payload
  (let ((data (get-password-auth-payload '"alice" '"asecret"))
        (expected `'""))
    (: lfe-utils dump-data '"passwd-data" data)
    (is-equal expected data)))

; XXX this unit test is currently broken
(deftest get-apikey-auth-payload
  (let ((data (get-apikey-auth-payload '"alice" '"123abc"))
        (expected `'""))
    (: lfe-utils dump-data '"apikey-data" (: io_lib format '"~s~n" (list data)))
    (is-equal expected data)))

