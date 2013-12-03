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
