(defmodule openstack-servers_tests
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
    (from openstack-servers
          (get-name-id 1)
          (get-flavor-id 2)
          (get-images-id 2)
          (get-new-server-payload 3))))


(defun get-new-server-payload_test ()
  (let ((data (get-new-server-payload '"my server" '"as-12-df" '"perf-2"))
        (expected #((#(server
                        #((#(name #B(109 121 32 115 101 114 118 101 114))
                           #(imageRef #B(97 115 45 49 50 45 100 102))
                           #(flavorRef #B(112 101 114 102 45 50)))))))))
    (assert-equal expected data)))
