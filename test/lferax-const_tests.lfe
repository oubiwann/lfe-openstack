(defmodule lferax-const_tests
  (export all)
  (import
    (from lfeunit-util
          (check-failed-assert 2)
          (check-wrong-assert-exception 2))
    (from lfeunit
          (assert 1)
          (assert-not 1)
          (assert-equal 2)
          (assert-not-equal 2)
          (assert-exception 3)
          (assert-error 2)
          (assert-throw 2)
          (assert-exit 2))))


(defun auth-url_test ()
  (assert-equal
    '"https://identity.api.rackspacecloud.com/v2.0/tokens"
    '(: lferax-const auth-url)))

(defun services_test ()
  (assert-equal
    '"cloudServers"
    `(: dict fetch 'servers-v1 (: lferax-const services)))
  (assert-equal
    '"cloudServersOpenStack"
    `(: dict fetch 'servers-v2 (: lferax-const services)))
  (assert-equal
    '"cloudLoadBalancers"
    `(: dict fetch 'load-balancers (: lferax-const services)))
  (assert-equal 10 (: dict size (: lferax-const services))))

(defun regions_test ()
  (assert-equal
    '"SYD"
    `(: dict fetch 'syd (: lferax-const regions)))
  (assert-equal
    '"DFW"
    `(: dict fetch 'dfw (: lferax-const regions)))
  (assert-equal
    '"ORD"
    `(: dict fetch 'ord (: lferax-const regions)))
  (assert-equal 5 (: dict size (: lferax-const regions))))

(defun files_test ()
  (assert-equal '"~/.rax/username" `(: lferax-const username-file))
  (assert-equal '"~/.rax/password" `(: lferax-const password-file))
  (assert-equal '"~/.rax/apikey" `(: lferax-const apikey-file)))

(defun env_test ()
  (assert-equal '"RAX_USERNAME" `(: lferax-const username-env))
  (assert-equal '"RAX_PASSWORD" `(: lferax-const password-env))
  (assert-equal '"RAX_APIKEY" `(: lferax-const apikey-env)))
