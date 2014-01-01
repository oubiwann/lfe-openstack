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
  (: openstack-util dict (test-dict-data-2)))

(defun partition-list_test ()
  (let ((result (: openstack-util partition-list (test-dict-data-2))))
    (assert-equal #((key-1 key-2) ("value 1" "value 2")) result)))

(defun dict_test ()
  (assert-equal '"value 1" `(: dict fetch 'key-1 ,(test-dict-2)))
  (assert-equal '"value 2" `(: dict fetch 'key-2 ,(test-dict-2))))

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

(defun is-home-dir?_test ()
  (assert-not `(: openstack-util is-home-dir? '"~"))
  (assert-not `(: openstack-util is-home-dir? '"/"))
  (assert-not `(: openstack-util is-home-dir? '"~home/"))
  (assert-not `(: openstack-util is-home-dir? '"/home"))
  (assert `(: openstack-util is-home-dir? '"~/"))
  (assert `(: openstack-util is-home-dir? '"~/user"))
  (assert `(: openstack-util is-home-dir? '"~/user/more/path")))

(defun expand-home-dir_test ()
  (assert-equal '"/usr/local/bin"
                `(: openstack-util expand-home-dir '"/usr/local/bin"))
  (assert-equal '"/home/oubiwann"
                `(: openstack-util expand-home-dir '"/home/oubiwann"))
  ;; lfeunit has some issues with the following tests...
  ;(let* ((tilde-dir '"~/my-data")
  ;       (expanded (: openstack-util expand-home-dir tilde-dir)))
  ;  (assert `(: openstack-util is-home-dir? ,tilde-dir))
  ;  (assert-not `(: openstack-util is-home-dir? ,expanded)))
  )

(defun strip_test ()
  (assert-equal '"data" `(: openstack-util strip '"data\n"))
  (assert-equal '"data" `(: openstack-util strip '"data\n\n"))
  (assert-equal '"data" `(: openstack-util strip '"data   "))
  (assert-equal '"data" `(: openstack-util strip '"data   \n   "))
  (assert-equal '"data" `(: openstack-util strip '"data   \n   \n")))
