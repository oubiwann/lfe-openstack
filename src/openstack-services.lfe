(defmodule openstack-services
  (export all))


(defun get-service-catalog (identity-response)
  (: ej get
     #("access" "serviceCatalog")
     (: openstack-util get-json-body identity-response)))

(defun get-service-endpoints (identity-response service-type)
  (: ej get
    (tuple (tuple 'select (tuple '"name" service-type)) '"endpoints")
    (get-service-catalog identity-response)))

