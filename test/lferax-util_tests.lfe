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

(defun json-wrap_test ()
  (assert-equal #(("my data")) (: lferax-util json-wrap '"my data"))
  (assert-equal #(("my data 1" "my data 2"))
                (: lferax-util json-wrap '"my data 1" '"my data 2")))

(defun is-home-dir?_test ()
  (assert-not `(: lferax-util is-home-dir? '"~"))
  (assert-not `(: lferax-util is-home-dir? '"/"))
  (assert-not `(: lferax-util is-home-dir? '"~home/"))
  (assert-not `(: lferax-util is-home-dir? '"/home"))
  (assert `(: lferax-util is-home-dir? '"~/"))
  (assert `(: lferax-util is-home-dir? '"~/user"))
  (assert `(: lferax-util is-home-dir? '"~/user/more/path")))

(defun expand-home-dir_test ()
  (assert-equal '"/usr/local/bin"
                `(: lferax-util expand-home-dir '"/usr/local/bin"))
  (assert-equal '"/home/oubiwann"
                `(: lferax-util expand-home-dir '"/home/oubiwann"))
  ;; lfeunit has some issues with the following tests...
  ;(let* ((tilde-dir '"~/my-data")
  ;       (expanded (: lferax-util expand-home-dir tilde-dir)))
  ;  (assert `(: lferax-util is-home-dir? ,tilde-dir))
  ;  (assert-not `(: lferax-util is-home-dir? ,expanded)))
  )

(defun strip_test ()
  (assert-equal '"data" `(: lferax-util strip '"data\n"))
  (assert-equal '"data" `(: lferax-util strip '"data\n\n"))
  (assert-equal '"data" `(: lferax-util strip '"data   "))
  (assert-equal '"data" `(: lferax-util strip '"data   \n   "))
  (assert-equal '"data" `(: lferax-util strip '"data   \n   \n")))
