(defmodule openstack-const
  (export all)
  (import
    (from openstack-util
          (dict 1))))


;; Authentication Endpoints
(defun auth-url () '"https://identity.api.rackspacecloud.com/v2.0/tokens")
(defun auth-url-uk () '"https://lon.identity.api.rackspacecloud.com/v2.0/tokens")

;; HTTP Header Names
(defun content-type () '"Content-Type")
(defun user-agent () '"User-Agent")
(defun x-auth-user () '"X-Auth-User")
(defun x-server-management-url () '"X-Server-Management-Url")
(defun x-auth-key () '"X-Auth-Key")
(defun x-storage-url () '"X-Storage-Url")
(defun x-auth-token () '"X-Auth-Token")

;; User Agent Data
(defun user-agent-name () '"LFE (Lisp Flavored Erlang) Rackspace Cloud Client")
(defun user-agent-version () '"0.0.1")
(defun user-agent-url () '"(+https://github.com/oubiwann/lfe-rackspace)")
(defun user-agent-string () (++ (user-agent-name)
                                '"/"(user-agent-version)
                                '" "(user-agent-url)))

;; Credential Information
(defun dot-dir () '"~/.rax")
(defun username-file () (: filename join (list (dot-dir) '"username")))
(defun password-file () (: filename join (list (dot-dir) '"password")))
(defun apikey-file () (: filename join (list (dot-dir) '"apikey")))
(defun username-env () '"RAX_USERNAME")
(defun password-env () '"RAX_PASSWORD")
(defun apikey-env () '"RAX_APIKEY")

;; Rackspace Cloud Services
(defun services ()
  (dict
    (list
      'servers-v2 '"cloudServersOpenStack"
      'servers-v1 '"cloudServers"
      'files-cdn '"cloudFilesCDN"
      'files '"cloudFiles"
      'databases '"cloudDatabases"
      'backup '"cloudBackup"
      'block-storage '"cloudBlockStorage"
      'dns '"cloudDNS"
      'load-balancers '"cloudLoadBalancers"
      'monitoring '"cloudMonitoring")))

;; Rackspace Cloud Regions
(defun regions ()
  (dict
    (list
      'syd '"SYD"
      'dfw '"DFW"
      'ord '"ORD"
      'hkg '"HKG"
      'iad '"IAD")))
