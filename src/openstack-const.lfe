(defmodule openstack-const
  (export all)
  (import
    (from openstack-util
          (dict 1))))


;; HTTP Header Names
(defun content-type () '"Content-Type")
(defun user-agent () '"User-Agent")
(defun x-auth-user () '"X-Auth-User")
(defun x-server-management-url () '"X-Server-Management-Url")
(defun x-auth-key () '"X-Auth-Key")
(defun x-storage-url () '"X-Storage-Url")
(defun x-auth-token () '"X-Auth-Token")

;; User Agent Data
(defun user-agent-name () '"LFE (Lisp Flavored Erlang) OpenStack Cloud Client")
(defun user-agent-version () '"0.0.1")
(defun user-agent-url () '"(+https://github.com/oubiwann/lfe-openstack)")
(defun user-agent-string () (++ (user-agent-name)
                                '"/"(user-agent-version)
                                '" "(user-agent-url)))

;; Credential Information
(defun dot-dir () '"~/.openstack")
(defun username-file () (: filename join (list (dot-dir) '"username")))
(defun password-file () (: filename join (list (dot-dir) '"password")))
(defun tenant-file () (: filename join (list (dot-dir) '"tenant")))
(defun auth-url-file () (: filename join (list (dot-dir) '"auth-url")))
(defun username-env () '"OS_USERNAME")
(defun password-env () '"OS_PASSWORD")
(defun tenant-env () '"OS_TENANT_NAME")
(defun auth-url-env () '"OS_AUTH_URL")
(defun config-file () (: filename join (list (dot-dir) '"providers.cfg")))

;; Default OpenStack Cloud Services
(defun services ()
  (dict
    (list
      'identity '"keystone"
      'compute '"nova"
      'image '"galance"
      'block-storage '""
      'networking '""
      'object-storage '""
      'orchestration '""
      'telemetry '"")))

