(defmodule lferax-const
  (export all)
  (import
    (from lferax-util
          (dict 1))))


(defun auth-url () '"https://identity.api.rackspacecloud.com/v2.0/tokens")
(defun user-agent-name () '"LFE Rackspace Cloud HTTP Client/0.0.1")
(defun user-agent-url () '"https://github.com/oubiwann/lfe-rackspace")
(defun user-agent () (++ (user-agent-name) '" " (user-agent-url)))
(defun x-auth-user () '"X-Auth-User")
(defun x-server-management-url () '"X-Server-Management-Url")
(defun x-auth-key () '"X-Auth-Key")
(defun x-storage-url () '"X-Storage-Url")
(defun x-auth-token () '"X-Auth-Token")

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

(defun regions ()
  (dict
    (list
      'syd '"SYD"
      'dfw '"DFW"
      'ord '"ORD"
      'iad '"IAD")))
