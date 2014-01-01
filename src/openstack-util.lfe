(defmodule openstack-util
  (export all)
  (import
    (from lfe-utils
          (partition-list 1))))


(defun json-wrap (data)
  "Ugh. I'm not a fan of JSON in Erlang. Really not a fan."
  (let* (((tuple keys values) (partition-list data))
         (pairs (: lists zip keys values)))
    (tuple pairs)))

(defun json-wrap-bin (data)
  "Same as above, but convert values to binary in addition."
  (let* (((tuple keys values) (partition-list data))
         (values (: lists map #'list_to_binary/1 values))
         (pairs (: lists zip keys values)))
    (tuple pairs)))

(defun start-services ()
  (: inets start)
  (: ssl start))

(defun read-file (filename)
  (let* ((full-path (: lfe-utils expand-home-dir filename))
         ((tuple 'ok data) (: file read_file full-path)))
    (: lfe-utils strip (binary_to_list data))))

(defun parse-response-ok (response)
  (let (((tuple erlang-ok-status
                (tuple (tuple http-version
                              http-status-code
                              http-status-message)
                       headers
                       body)) response))
    (list erlang-ok-status
          http-version
          http-status-code
          http-status-message
          (: dict from_list headers)
          body)))

; XXX this needs to be implemented
(defun parse-response-error (response)
  )

(defun get-body (response)
  (let (((list _ _ _ _ _ body) (parse-response-ok response)))
    body))

(defun get-json-body (response)
  (: jiffy decode
    (get-body response)))


