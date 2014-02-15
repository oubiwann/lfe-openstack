(defmodule openstack-const_tests
  (export all)
  (import
    (from lfeunit-util
          (check-failed-assert 2)
          (check-wrong-is-exception 2))))

(include-lib "deps/lfeunit/include/lfeunit-macros.lfe")

(deftest services
  (is-equal
    '"keystone"
    (: dict fetch 'identity (: openstack-const services)))
  (is-equal
    '"nova"
    (: dict fetch 'compute (: openstack-const services)))
  (is-equal
    '""
    (: dict fetch 'networking (: openstack-const services)))
  (is-equal 8 (: dict size (: openstack-const services))))

(deftest files
  (is-equal '"~/.openstack/username" (: openstack-const username-file))
  (is-equal '"~/.openstack/password" (: openstack-const password-file))
  (is-equal '"~/.openstack/tenant" (: openstack-const tenant-file))
  (is-equal '"~/.openstack/auth-url" (: openstack-const auth-url-file)))

(deftest env
  (is-equal '"OS_USERNAME" (: openstack-const username-env))
  (is-equal '"OS_PASSWORD" (: openstack-const password-env))
  (is-equal '"OS_TENANT_NAME" (: openstack-const tenant-env))
  (is-equal '"OS_AUTH_URL" (: openstack-const auth-url-env)))

(deftest config
  (is-equal '"~/.openstack/providers.cfg" (: openstack-const config-file)))

