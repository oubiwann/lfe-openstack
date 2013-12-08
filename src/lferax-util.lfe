(defmodule lferax-util
  (export all))


(defun partition-list (list-data)
  "This function takes lists of even length with an implicit key (atom) value
  pairing and generates a list of two lists: one with all the keys, and the
  other with all the values."
  (: lists partition #'is_atom/1 list-data))

(defun dict (data)
  "'data' is a list of implicit pairs:
    * the odd elements are keys of type 'atom'
    * the even elemnts are the values.

  This list is partitioned. zipped to tuples, and then converted to a dict."
  (let (((tuple keys values) (partition-list data)))
    (: dict from_list
       (: lists zip keys values))))

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

(defun get-home-dir ()
  (let (((list (tuple 'home (list home)))
         (: lists sublist (: init get_arguments) 3 1)))
    home))

(defun is-home-dir? (path)
  (cond ((=:= '"~/" (: string substr path 1 2))
         'true)
        ('true 'false)))

(defun expand-home-dir (path-with-home)
  (cond ((is-home-dir? path-with-home)
         (: filename join (list (get-home-dir)
                                (: string substr path-with-home 3))))
        ('true path-with-home)))

(defun strip (string)
  (: re replace
     string
     '"(^\\s+)|(\\s+$)"
      ""
      (list 'global (tuple 'return 'list))))

(defun read-file (filename)
  (let (((tuple 'ok data) (: file read_file (expand-home-dir filename))))
    (strip (binary_to_list data))))

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


