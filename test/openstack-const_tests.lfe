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


(defun services_test ()
  (assert-equal
    '""
    `(: dict fetch 'identity (: openstack-const services)))
  (assert-equal
    '""
    `(: dict fetch 'compute (: openstack-const services)))
  (assert-equal
    '""
    `(: dict fetch 'networking (: openstack-const services)))
  (assert-equal 8 (: dict size (: openstack-const services))))

(defun files_test ()
  (assert-equal '"~/.openstack/username" `(: openstack-const username-file))
  (assert-equal '"~/.openstack/password" `(: openstack-const password-file))
  (assert-equal '"~/.openstack/tenant" `(: openstack-const tenant-file))
  (assert-equal '"~/.openstack/auth-url" `(: openstack-const auth-url-file)))

(defun env_test ()
  (assert-equal '"OS_USERNAME" `(: openstack-const username-env))
  (assert-equal '"OS_PASSWORD" `(: openstack-const password-env))
  (assert-equal '"OS_TENANT_NAME" `(: openstack-const tenant-env))
  (assert-equal '"OS_AUTH_URL" `(: openstack-const auth-url-env)))
