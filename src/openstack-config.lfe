(defmodule openstack-config
  (export all))

(defun open ()
  (: application start 'gproc)
  (: application start 'econfig)
  (: econfig open_config 'os-config
    (: openstack-util expand-home-dir (: openstack-const config-file))))

(defun get-value (section key)
  (open)
  (: econfig get_value 'os-config section key))

(defun get-username (provider)
  (get-value provider '"username"))

(defun get-password (provider)
  (get-value provider '"password"))

(defun get-apikey (provider)
  (get-value provider '"apikey"))

(defun get-tenant (provider)
  (get-value provider '"tenant"))

(defun get-auth-url (provider)
  (get-value provider '"auth-url"))

(defun close ()
  (: econfig unregister_config 'os-config)
  (: application stop 'gproc)
  (: application stop 'econfig))
