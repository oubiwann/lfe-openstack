(defmodule openstack-config
  (export all))

(defun open (config-file)
  (: application start 'gproc)
  (: application start 'econfig)
  (: econfig open_config 'os-config
    (: lfe-utils expand-home-dir config-file)))

(defun open ()
  (open (: openstack-const config-file)))

(defun get-value (config-file section key)
  (open config-file)
  (: econfig get_value 'os-config section key))

(defun get-value (section key)
  (get-value (: openstack-const config-file) section key))

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
