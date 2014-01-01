(defmodule openstack-util_tests
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


(defun test-dict-data-1 ()
  (list
    'key-1 '"value 1"))

(defun test-dict-data-2 ()
  (list
    'key-1 '"value 1"
    'key-2 '"value 2"))

(defun test-dict-data-3 ()
  (list
    'key-1 '"value 1"
    'key-2 '"value 2"
    'key-3 '"value 3"))

(defun test-dict-2 ()
  (: lfe-util pair-dict (test-dict-data-2)))

(defun json-wrap_test ()
  (let ((result-1 (: openstack-util json-wrap (test-dict-data-1)))
        (result-2 (: openstack-util json-wrap (test-dict-data-2)))
        (result-3 (: openstack-util json-wrap (test-dict-data-3))))
    (assert-equal #((#(key-1 "value 1"))) result-1)
    (assert-equal #((#(key-1 "value 1") #(key-2 "value 2"))) result-2)
    (assert-equal #((#(key-1 "value 1") #(key-2 "value 2") #(key-3 "value 3")))
                  result-3)))

(defun json-wrap-bin_test ()
  (let ((result-1 (: openstack-util json-wrap-bin (test-dict-data-1)))
        (result-2 (: openstack-util json-wrap-bin (test-dict-data-2)))
        (result-3 (: openstack-util json-wrap-bin (test-dict-data-3))))
    (assert-equal #((#(key-1 #B(118 97 108 117 101 32 49))))
                  result-1)
    (assert-equal #((#(key-1 #B(118 97 108 117 101 32 49))
                     #(key-2 #B(118 97 108 117 101 32 50))))
                  result-2)
    (assert-equal #((#(key-1 #B(118 97 108 117 101 32 49))
                     #(key-2 #B(118 97 108 117 101 32 50))
                     #(key-3 #B(118 97 108 117 101 32 51))))
                  result-3)))


