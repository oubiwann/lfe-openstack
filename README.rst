#############
lfe-rackspace
#############

Pure LFE (Lisp Flavored Erlang) language bindings for the Rackspace Cloud

Plase note: this library is in an early stage of development and is not yet usable as a complete API.

.. contents:: Table of Contents


Introduction
************

Inspired by the experimental `Clojure bindings`_ for the Rackspace Cloud, these
bindings provide Erlang/OTP and LFE/OTP programmers with a native API for
creating and managing serviers in Rackspace's OpenStack cloud.

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
* `lfeunit`_ (needed only to run the unit tests)
* `lfe-utils`_ (various convenience functions)

If you plan on installing lfe-rackspace system-wide, you will need to install
these dependencies before using lfe-rackspace.


Installation
************

To install, simply do the following:

.. code:: bash

    $ git clone https://github.com/oubiwann/lfe-rackspace.git
    $ cd lfe-rackspace
    $ sudo ERL_LIB=`erl -eval 'io:fwrite(code:lib_dir()), halt().' -noshell` \
          make install

We don't, however, recommend using ``lfe-rackspace`` like this. Rather, using it
with ``rebar`` from the ``clone`` ed directory.

If you have another project where you'd like to utilize ``lfe-rackspace``, then
add it to your ``deps`` in the project ``rebar.config`` file.

You can also run the test suite from ``lfe-rackspace``:

.. code:: bash

    $ make check

Which should give you output something like the following:

.. code:: bash

    ==> lfe-rackspace (eunit)
    ======================== EUnit ========================
    module 'lferax-util_tests'
      lferax-util_tests: dict_test...[0.085 s] ok
      lferax-util_tests: json-wrap_test...ok
      lferax-util_tests: is-home-dir?_test...ok
      lferax-util_tests: expand-home-dir_test...ok
      lferax-util_tests: strip_test...ok
      [done in 0.100 s]
    module 'lferax-identity_tests'
      lferax-identity_tests: build-creds-password_test...[0.046 s] ok
      lferax-identity_tests: build-creds-apikey_test...ok
      [done in 0.051 s]
    module 'lferax-const_tests'
      lferax-const_tests: auth-url_test...[0.052 s] ok
      lferax-const_tests: services_test...ok
      lferax-const_tests: regions_test...ok
      lferax-const_tests: files_test...ok
      lferax-const_tests: env_test...ok
      [done in 0.067 s]
    =======================================================
      All 12 tests passed.


Usage
*****

Login
=====

``lfe-rackspace`` provides several ways to pass your authentication credentials
to the API:


Directly, using ``login/3``
---------------------------

.. code:: common-lisp

    > (: lferax-identity login '"alice" 'apikey `"1234abcd")

or

.. code:: common-lisp

    > (: lferax-identity login '"alice" 'password `"asecret")


Indirectly, using ``login/0``
-----------------------------

.. code:: bash

    $ export RAX_USERNAME=alice
    $ export RAX_APIKEY=1234abcd

.. code:: common-lisp

    > (: lferax-identity login)

or

.. code:: bash

    $ cat "alice" > ~/.rax/username
    $ cat "1234abcd" > ~/.rax/apikey

.. code:: common-lisp

    > (: lferax-identity login)


Indirectly, using ``login/1``
-----------------------------

.. code:: bash

    $ export RAX_USERNAME=alice
    $ export RAX_PASSWORD=asecret

.. code:: common-lisp

    > (: lferax-identity login 'password)

or

.. code:: bash

    $ cat "alice" > ~/.rax/username
    $ cat "asecret" > ~/.rax/password

.. code:: common-lisp

    > (: lferax-identity login 'password)

In the presence of both defined env vars and cred files, env will allways be
the default source of truth and files will only be used in the absence of
defined env vars.


Login Response Data
-------------------

After successfully logging in, you will get a response with a lot of data in
it. You will need this data to perform additional tasks, so make sure you save
it. From the LFE REPL, this would look like so:

.. code:: common-lisp

    (set response (: lferax-identity login))

There's a utility function we can use here to extract the parts of the
response.

.. code:: common-lisp

    (set (list erlang-ok-status
               http-version
               http-status-code
               http-status-message
               headers
               body)
         (: lferax-util parse-json-response-ok response))

Be aware that this function assumes a non-error Erlang result. If the first
element of the returned data struction is ``error`` and not ``ok``, this
function call will fail.


User Auth Token
---------------

With the response data from a successful login, one may then get one's token:

.. code:: common-lisp

    (set token (: lferax-identity get-token response))


Tentant ID
----------

TThe tenant ID is an important bit of information that you will need for
further calls to the Rackspace Cloud APIs. You get it in the same manner:


.. code:: common-lisp

    (set tenant-id (: lferax-identity get-tenant-id response))



User Info
---------

Simiarly, after login, you will be able to extract your user id:

.. code:: common-lisp

    (set user-id (: lferax-identity get-user-id response))
    (set user-name (: lferax-identity get-user-name response))



Service Data
============

The response data from a successful login holds all the information you need to
access the rest of Rackspace cloud services. The following subsections detail
some of these.

Note that many of these calls will return Rackspace API server response data as
JSON data decoded to Erlang binary. As such, you will often see data like this
after calling an API function:

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

To get a list of the services provided by Rackspace:

.. code:: common-lisp

    (: lferax-services get-service-catalog response)


Service Endpoints
-----------------

To get the endpoints for a particular service:

.. code:: common-lisp

    (: lferax-services get-service-endpoints response '"cloudServersOpenStack")

The full list of available endpoints is provided in ``(: lferax-consts services)``.

We provide some alias functions for commonly used service endpoints, e.g.:

.. code:: common-lisp

    (: lferax-services get-cloud-servers-v2-endpoints response)


Region Endpoint URL
-------------------

Furthermore, you can get a services URL by region:

.. code:: common-lisp

    (: lferax-services get-cloud-servers-v2-url response '"DFW")

A full list of regions that can be passed (as in "DFW" above) is
provided in ``(: lferax-consts services)``.


Cloud Servers
=============


Getting Image List
------------------

TBD


Creating a Server
-----------------

TBD


Utility Functions
=================

TBD


.. Links
.. -----
.. _Clojure bindings: https://github.com/oubiwann/clj-rackspace
.. _rebar: https://github.com/rebar/rebar
.. _LFE: https://github.com/rvirding/lfe
.. _Jiffy: https://github.com/davisp/jiffy
.. _lfeunit: https://github.com/lfe/lfeunit
.. _lfe-utils: https://github.com/lfe/lfe-utils
