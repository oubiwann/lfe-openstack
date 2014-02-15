(defmodule openstack-services_tests
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

(defun noop ())
