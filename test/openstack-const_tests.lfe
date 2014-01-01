(defmodule openstack-const_tests
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
    '(: openstack-const auth-url)))

(defun services_test ()
  (assert-equal
    '"cloudServers"
    `(: dict fetch 'servers-v1 (: openstack-const services)))
  (assert-equal
    '"cloudServersOpenStack"
    `(: dict fetch 'servers-v2 (: openstack-const services)))
  (assert-equal
    '"cloudLoadBalancers"
    `(: dict fetch 'load-balancers (: openstack-const services)))
  (assert-equal 10 (: dict size (: openstack-const services))))

(defun regions_test ()
  (assert-equal
    '"SYD"
    `(: dict fetch 'syd (: openstack-const regions)))
  (assert-equal
    '"DFW"
    `(: dict fetch 'dfw (: openstack-const regions)))
  (assert-equal
    '"ORD"
    `(: dict fetch 'ord (: openstack-const regions)))
  (assert-equal 5 (: dict size (: openstack-const regions))))

(defun files_test ()
  (assert-equal '"~/.rax/username" `(: openstack-const username-file))
  (assert-equal '"~/.rax/password" `(: openstack-const password-file))
  (assert-equal '"~/.rax/apikey" `(: openstack-const apikey-file)))

(defun env_test ()
  (assert-equal '"RAX_USERNAME" `(: openstack-const username-env))
  (assert-equal '"RAX_PASSWORD" `(: openstack-const password-env))
  (assert-equal '"RAX_APIKEY" `(: openstack-const apikey-env)))
