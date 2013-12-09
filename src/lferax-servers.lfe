(defmodule lferax-servers
  (export all)
  (import
    (from lferax-util
          (json-wrap 1)
          (json-wrap-bin 1))))


(defun get-name-id (json-data)
  "Given some JSON data, parse just 'name' and 'id' attributes."
  (tuple
    (: ej get #("name") json-data)
    (tuple (: ej get #("id") json-data))))

(defun get-data (identity-response url-path region)
  (let* ((base-url (: lferax-services get-cloud-servers-v2-url
                     identity-response
                     region))
         (url (++ base-url url-path)))
  (: lferax-util get-json-body
    (: lferax-http get
       url
       (: lferax-identity get-token identity-response)))))

; XXX refactor this (generalize/abtract for reuse)
(defun get-flavors-list (identity-response region)
  (: lists map
     #'get-name-id/1
     (: ej get
        #("flavors")
        (get-data identity-response
                  '"/flavors"
                  region))))

; XXX refactor this (generalize/abtract for reuse)
(defun get-flavor-id (flavor-name flavors-list)
  (binary_to_list
    (element 1
             (: dict fetch
                (list_to_binary flavor-name)
                (: dict from_list flavors-list)))))

; XXX refactor this (generalize/abtract for reuse)
(defun get-images-list (identity-response region)
  (: lists map
     #'get-name-id/1
     (: ej get
        #("images")
        (get-data identity-response
                  '"/images"
                  region))))

; XXX refactor this (generalize/abtract for reuse)
(defun get-image-id (image-name images-list)
  (binary_to_list
    (element 1
             (: dict fetch
                (list_to_binary image-name)
                (: dict from_list images-list)))))

(defun get-new-server-payload (server-name image-id flavor-id)
  "Jiffy doesn't handle strings well for JSON, though it does handle binaries
  well. As such, all strings should be converted to binary before being passed
  to Jiffy."
  (json-wrap
    (list 'server
          (json-wrap-bin (list 'name server-name
                               'imageRef image-id
                               'flavorRef flavor-id)))))

(defun get-new-server-encoded-payload (server-name image-id flavor-id)
  (binary_to_list
    (: jiffy encode (get-new-server-payload server-name image-id flavor-id))))

(defun create-server (identity-response region server-name image-id flavor-id)
  (let ((base-url (: lferax-services get-cloud-servers-v2-url
                    identity-response
                    region)))
    (: lferax-http post
      (++ base-url '"/servers")
      (get-new-server-encoded-payload server-name image-id flavor-id)
      (: lferax-identity get-token identity-response))))

(defun get-server-list (identity-response region)
  (let ((base-url (: lferax-services get-cloud-servers-v2-url
                     identity-response
                     region)))
    (: lferax-http get
      (++ base-url '"/servers/detail")
      region
      (: lferax-identity get-token identity-response))))

