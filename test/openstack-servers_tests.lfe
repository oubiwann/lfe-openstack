(defmodule openstack-servers_tests
  (export all)
  (import
    (from lfeunit-util
          (check-failed-assert 2)
          (check-wrong-is-exception 2))
    (rename lfe-rest-client
            ((get-default-headers 1) get-headers))
    (from lfe-rest-client-util
          (get-body 1))))

(include-lib "deps/lfeunit/include/lfeunit-macros.lfe")

(deftest get-new-server-payload
  (let ((data (get-new-server-payload '"my server" '"as-12-df" '"perf-2"))
        (expected #((#(server
                        #((#(name #B(109 121 32 115 101 114 118 101 114))
                           #(imageRef #B(97 115 45 49 50 45 100 102))
                           #(flavorRef #B(112 101 114 102 45 50)))))))))
    (is-equal expected data)))
