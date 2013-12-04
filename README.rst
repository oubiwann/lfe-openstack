#############
lfe-rackspace
#############

Pure LFE (Lisp Flavored Erlang) language bindings for the Rackspace Cloud

.. contents:: Table of Contents


Introduction
************

Inspired by the experimental Clojure bindings for the Rackspace Cloud, these
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


Usage
*****

Login
=====

``lfe-rackspace`` provides several ways to pass your authentication credentials
to the API:

* Directly, using ``login/3``:

.. code:: common-lisp

    > (: lferax-identity login '"alice" 'apikey `"1234abcd")

or

.. code:: common-lisp

    > (: lferax-identity login '"alice" 'password `"asecret")

* Indirectly, using ``login/0``:

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

* Indirectly, using ``login/1``:

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

Note that in the presence of both defined env vars and cred files, env will
allways be the default source of truth and files will only be used in the
absence of defined env vars.

After successfully logging in, you will get a response with a lot of data in
it. You will need this data to perform additional tasks, so make sure you save
it. From the LFE REPL, this would look like so:

.. code:: common-lisp

    (set response (: lferax-identity login))


Service Data
============

The response data from a successful login holds all the information you need to
access the rest of Rackspace cloud services. The following subsections detail
some of these.

TBD



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
.. _rebar: https://github.com/rebar/rebar
.. _LFE: https://github.com/rvirding/lfe
.. _Jiffy: https://github.com/davisp/jiffy
.. _lfeunit: https://github.com/lfe/lfeunit
.. _lfe-utils: https://github.com/lfe/lfe-utils
