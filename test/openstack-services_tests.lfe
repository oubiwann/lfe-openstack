(defmodule openstack-services_tests
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
          (assert-exit 2))
    (from openstack-identity
          (build-creds 3)
          (get-password-auth-payload 2)
          (get-apikey-auth-payload 2))))

(defun noop ())
