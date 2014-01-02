#############
lfe-openstack
#############

Pure LFE (Lisp Flavored Erlang) language bindings for OpenStack Clouds

Plase note: this library is in an early stage of development and is not yet
usable as a complete API.

.. contents:: Table of Contents


Introduction
************

Inspired by the experimental `Clojure bindings`_ for OpenStack clouds, these
bindings provide Erlang/OTP and LFE/OTP programmers with a native API for
creating and managing serviers in OpenStack clouds.

This API is written in LFE, but because LFE is 100% compatible with Erang Core,
when compiled to ``.beam`` files, they are just as easy to integrate with other
projects written in Erlang.


Dependencies
============

This project assumes that you have `rebar`_ installed somwhere in your
``$PATH``.

This project depends upon the following, which installed to the ``deps``
directory of this project when you run ``make deps``:

* `LFE`_ (Lisp Flavored Erlang; needed only to compile)
* `Jiffy`_ (JSON-parsing library)
* `econfig`_ (Erlang config/ini parser)
* `lfeunit`_ (needed only to run the unit tests)
* `lfe-utils`_ (various convenience functions)

If you plan on installing lfe-openstack system-wide, you will need to install
these dependencies before using lfe-openstack.


Installation
************

To install, simply do the following:

.. code:: bash

    $ git clone https://github.com/oubiwann/lfe-openstack.git
    $ cd lfe-openstack
    $ sudo ERL_LIB=`erl -eval 'io:fwrite(code:lib_dir()), halt().' -noshell` \
          make install

We don't, however, recommend using ``lfe-openstack`` like this. Rather, use it
with ``rebar`` from the ``clone`` ed directory.

If you have another project where you'd like to utilize ``lfe-openstack``, then
add it to your ``deps`` in the project ``rebar.config`` file.

You can also run the test suite from ``lfe-openstack``:

.. code:: bash

    $ make check

Which should give you output something like the following:

.. code:: bash

    ==> lfe-openstack (eunit)
    ======================== EUnit ========================
    module 'openstack-util_tests'
      openstack-util_tests: partition-list_test...[0.037 s] ok
      openstack-util_tests: dict_test...ok
      openstack-util_tests: json-wrap_test...ok
      openstack-util_tests: json-wrap-bin_test...ok
      openstack-util_tests: is-home-dir?_test...ok
      openstack-util_tests: expand-home-dir_test...ok
      openstack-util_tests: strip_test...ok
      [done in 0.058 s]
    module 'openstack-services_tests'
    openstack-servers_tests: get-new-server-payload_test (module 'openstack-servers_tests')...[0.020 s] ok
    openstack-identity_tests: build-creds-password_test (module 'openstack-identity_tests')...[0.019 s] ok
    module 'openstack-http_tests'
      openstack-http_tests: get-default-headers_test...[0.030 s] ok
      openstack-http_tests: get-auth-headers_test...ok
      openstack-http_tests: get_test...[1.306 s] ok
      [done in 1.345 s]
    module 'openstack-const_tests'
      openstack-const_tests: services_test...ok
      openstack-const_tests: files_test...ok
      openstack-const_tests: env_test...
      openstack-const_tests: config_test...ok
      [done in 0.012 s]
    =======================================================
      All 16 tests passed.


Usage
*****

Login
=====

``lfe-openstack`` provides several ways to pass your authentication credentials
to the API:


Directly, using ``login/3``
---------------------------

.. code:: common-lisp

    > (: openstack-identity login
        '"http://api.openstack.host:5000/v2.0/tokens"
        '"alice"
        '"secretpwd")


Indirectly, using ``login/2``
-----------------------------

To use this login method, you'll need to have the ``~/.openstack/providers.cfg``
file created, with content for each provider you want to be able to use. For
example:

.. code:: ini

  [openstack-host]
  username=alice
  password=secretpwd
  tenant-id=abc123
  auth-url=http://api.openstack.host:5000/v2.0/tokens

  [trystack]
  username=alice
  password=secret2
  tenant-id=efg456
  auth-url=http://trystack.org:5000/v2.0/tokens

With your providers config file set up, you can then do the following:

.. code:: common-lisp

    > (: openstack-identity login 'provider '"openstack-host")

or

.. code:: common-lisp

    > (: openstack-identity login 'provider '"trystack")

and the appropriate configuration data will be read from that file.


Indirectly, using ``login/0``
-----------------------------

If you have environment variables set or values stored in files, you can log in
without any parameters:

.. code:: bash

    $ export OS_USERNAME=alice
    $ export OS_PASSWORD=secretpwd
    $ export OS_AUTH_URL=http://api.openstack.host:5000/v2.0/tokens

or

.. code:: bash

    $ cat "alice" > ~/.openstack/username
    $ cat "secretpwd" > ~/.openstack/apikey
    $ cat "http://api.openstack.host:5000/v2.0/tokens" > ~/.openstack/auth-url

.. code:: common-lisp

    > (: openstack-identity login)

In the presence of both defined env vars and cred files, env will allways be
the default source of truth and files will only be used in the absence of
defined env vars.


Login Response Data
-------------------

After successfully logging in, you will get a response with a lot of data in
it. You will need this data to perform additional tasks, so make sure you save
it. From the LFE REPL, this would look like so:

.. code:: common-lisp

    (set auth-response (: openstack-identity login))

There's a utility function we can use here to extract the parts of the
response.

.. code:: common-lisp

    (set (list erlang-ok-status
               http-version
               http-status-code
               http-status-message
               headers
               body)
         (: openstack-util parse-json-response-ok auth-response))

Be aware that this function assumes a non-error Erlang result. If the first
element of the returned data struction is ``error`` and not ``ok``, this
function call will fail.


User Auth Token
---------------

With the response data from a successful login, one may then get one's token:

.. code:: common-lisp

    (set token (: openstack-identity get-token auth-response))


Tentant ID
----------

The tenant ID is an important bit of information that you will need for
further calls to OpenStack Cloud APIs. You get it in the same manner:


.. code:: common-lisp

    (set tenant-id (: openstack-identity get-tenant-id auth-response))



User Info
---------

Simiarly, after login, you will be able to extract your user id:

.. code:: common-lisp

    (set user-id (: openstack-identity get-user-id auth-response))
    (set user-name (: openstack-identity get-user-name auth-response))



Service Data
============

The response data from a successful login holds all the information you need to
access the rest of an OpenStack cloud's services. The following subsections
detail some of these.

Note that many of these calls will return an OpenStack API server's response
data as JSON data decoded to Erlang binary. As such, you will often see data
like this after calling an API function:

.. code:: common-lisp

    (#((#(#B(110 97 109 101) #B(99 108 111 117 100 70 105 108 101 115 67 68 78))
        #(#B(101 110 100 112 111 105 110 116 115)
          (#((#(#B(114 101 103 105 111 110) #B(68 70 87))
              #(#B(116 101 110 97 110 116 73 100)
              ...

Most of that data will be intermediary, and it won't matter that you can't read
it. However, if you ever feel the need to, you can display that binary in a
human-readable format: simply pass your data to
``(: io format '"~p~n" (list your-data))`` and you will see something like this
instead:

.. code:: erlang

    [{[{<<"name">>,<<"cloudFilesCDN">>},
       {<<"endpoints">>,
        [{[{<<"region">>,<<"DFW">>},
           {<<"tenantId">>,
           ...


List of Services
----------------

To get a list of the services provided by an OpenStack cloud:

.. code:: common-lisp

    (: openstack-services get-service-catalog auth-response)


Service Endpoints
-----------------

To get the endpoints for a particular service:

.. code:: common-lisp

    (: openstack-services get-service-endpoints auth-response
      '"cloudServersOpenStack")

The full list of available endpoints is provided in
``(: openstack-consts services)``. We recommend using the ``dict`` provided there,
keying off the appropriate atom for the service that you need, e.g.:

.. code:: common-lisp

    (set service (: dict fetch 'compute (: openstack-const services)))
    (: openstack-services get-service-endpoints auth-response service)


Cloud Servers
=============

WARNING: The following section has not been converted from lfe-rackspace yet.

For the conveneince of the reader, in the following examples, we will give each
command needed to go from initial login to final result.


Getting Flavors List
--------------------

.. code:: common-lisp

    ; function calls from before
    (set auth-response (: openstack-identity login))
    (set token (: openstack-identity get-token auth-response))
    (set region (: dict fetch 'dfw (: openstack-const regions)))
    ; new calls
    (set flavors-list (: openstack-servers get-flavors-list auth-response region))
    (: io format '"~p~n" (list flavors-list))

To get a particular flavor id from that list, you can use this convenience
function:

.. code:: common-lisp

    (set flavor-id (: openstack-servers get-id '"30 GB Performance" flavors-list))


Getting Images List
-------------------

.. code:: common-lisp

    ; function calls from before
    (set auth-response (: openstack-identity login))
    (set token (: openstack-identity get-token auth-response))
    (set region (: dict fetch 'dfw (: openstack-const regions)))
    ; new call
    (set images-list (: openstack-servers get-images-list auth-response region))
    (: io format '"~p~n" (list images-list))

To get a particular image id from that list, you can use this convenience
function:

.. code:: common-lisp

    (set image-id (: openstack-servers get-id
                    '"Ubuntu 12.04 LTS (Precise Pangolin)"
                    images-list))


Creating a Server
-----------------

.. code:: common-lisp

    ; function calls from before
    (set auth-response (: openstack-identity login))
    (set token (: openstack-identity get-token auth-response))
    (set region (: dict fetch 'dfw (: openstack-const regions)))
    (set flavors-list (: openstack-servers get-flavors-list auth-response region))
    (set flavor-id (: openstack-servers get-flavor-id
                     '"30 GB Performance"
                     flavors-list))
    (set images-list (: openstack-servers get-images-list auth-response region))
    (set image-id (: openstack-servers get-image-id
                    '"Ubuntu 12.04 LTS (Precise Pangolin)"
                    images-list))
    ; new calls
    (set server-name '"proj-server-1")
    (set server-response (: openstack-servers create-server
                           auth-response
                           region
                           server-name
                           image-id
                           flavor-id))

Getting a List of Servers
-------------------------

.. code:: common-lisp

    ; function calls from before
    (set auth-response (: openstack-identity login))
    (set token (: openstack-identity get-token auth-response))
    (set region (: dict fetch 'dfw (: openstack-const regions)))
    ; new call
    (set server-list (: openstack-servers get-server-list auth-response region))
    (: io format '"~p~n" (list server-list))


Utility Functions
=================

TBD


.. Links
.. -----
.. _Clojure bindings: https://github.com/oubiwann/clj-openstack
.. _rebar: https://github.com/rebar/rebar
.. _LFE: https://github.com/rvirding/lfe
.. _Jiffy: https://github.com/davisp/jiffy
.. _econfig: https://github.com/benoitc/econfig
.. _lfeunit: https://github.com/lfe/lfeunit
.. _lfe-utils: https://github.com/lfe/lfe-utils
