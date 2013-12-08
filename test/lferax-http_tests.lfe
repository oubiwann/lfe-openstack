(defmodule lferax-http_tests
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


(defun get_test ()
  (: inets start)
  (: meck new 'httpc)
  (: meck expect 'httpc 'request 4 (: lferax-testing-payloads simple-success))
  (try
    (let* ((raw-result (: lferax-http get '"http://my-url" '"" '""))
           (result (list_to_binary (: lferax-util get-body raw-result))))
      (assert-equal '"<html><body>Yay!</body></html>"
                    `(binary_to_list ,result)))
    (after
      (: meck validate 'httpc)
      (: meck unload 'httpc)
      (: inets stop))))
