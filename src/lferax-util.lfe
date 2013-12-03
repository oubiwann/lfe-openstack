(defmodule lferax-util
  (export all))


(defun dict (data)
  "'data' is a list of implicit pairs:
    * the odd elements are keys of type 'atom'
    * the even elemnts are the values.

  This list is partitioned. zipped to tuples, and then converted to a dict."
  (let (((tuple keys values) (: lists partition #'is_atom/1 data)))
    (: dict from_list
       (: lists zip keys values))))

(defun json-wrap (data)
  "Ugh. I'm not a fan of JSON in Erlang. Really not a fan."
  (tuple (list data)))

(defun json-wrap (data-1 data-2)
  (tuple (list data-1 data-2)))

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

(defun read-file (filename)
  (: file read_file (expand-home-dir filename)))
