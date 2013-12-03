(defmodule lferax-util_tests
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


(defun test-dict-data ()
  (list
    'key-1 '"value 1"
    'key-2 '"value 2"))

(defun test-dict-1 ()
  (: lferax-util dict (test-dict-data)))

(defun dict_test ()
  (assert-equal '"value 1" `(: dict fetch 'key-1 ,(test-dict-1)))
  (assert-equal '"value 2" `(: dict fetch 'key-2 ,(test-dict-1))))
