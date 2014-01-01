(defmodule openstack-http_tests
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


(defun get-default-headers_test()
  (let* ((result (: openstack-http get-default-headers '"my-content-type"))
         (data-check (list_to_binary (element 2 (car result))))
         (count (length result)))
    (assert-equal '"my-content-type" `(binary_to_list ,data-check))
    (assert-equal 2 count)))

(defun get-auth-headers_test()
  (let* ((result (: openstack-http get-auth-headers '"my-content-type" '"abc-tk"))
         (data-check (list_to_binary (element 2 (: lists last result))))
         (count (length result)))
    (assert-equal '"abc-tk" `(binary_to_list ,data-check))
    (assert-equal 3 count)))

(defun get_test ()
  (: inets start)
  (: meck new 'httpc)
  (: meck expect 'httpc 'request 4 (: openstack-testing-payloads simple-success))
  (try
    (let* ((raw-result (: openstack-http get '"http://my-url" '""))
           (result (list_to_binary (: openstack-util get-body raw-result))))
      (assert-equal '"<html><body>Yay!</body></html>"
                    `(binary_to_list ,result)))
    (after
      (: meck validate 'httpc)
      (: meck unload 'httpc)
      (: inets stop))))
