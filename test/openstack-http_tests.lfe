(defmodule openstack-http_tests
  (export all)
  (import
    (from lfeunit-util
          (check-failed-assert 2)
          (check-wrong-is-exception 2))))

(include-lib "deps/lfeunit/include/lfeunit-macros.lfe")

(deftest get-default-headers
  (let* ((result (: openstack-http get-default-headers '"my-content-type"))
         (data-check (element 2 (car result)))
         (count (length result)))
    (is-equal '"my-content-type" data-check)
    (is-equal 2 count)))

(deftest get-auth-headers
  (let* ((result (: openstack-http get-auth-headers '"my-content-type" '"abc-tk"))
         (data-check (element 2 (: lists last result)))
         (count (length result)))
    (is-equal '"abc-tk" data-check)
    (is-equal 3 count)))

(deftest get
  (: inets start)
  (: meck new 'httpc)
  (: meck expect 'httpc 'request 4 (: testing-payloads simple-success))
  (try
    (let* ((raw-result (: openstack-http get '"http://my-url" '""))
           (result (: openstack-util get-body raw-result)))
      (is-equal '"<html><body>Yay!</body></html>" result))
    (after
      (: meck validate 'httpc)
      (: meck unload 'httpc)
      (: inets stop))))
