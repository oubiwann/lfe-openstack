#############
lfe-rackspace
#############

Pure LFE (Lisp Flavored Erlang) language bindings for the Rackspace Cloud


Introduction
============

Inspired by the experimental Clojure bindings for the Rackspace Cloud, these
bindings provide Erlang/OTP and LFE/OTP programmers with a native API for
creating and managing serviers in Rackspace's OpenStack cloud.

This API is written in LFE, but because LFE is 100% compatible with Erang Core,
when compiled to ``.beam`` files, they are just as easy to integrate with other
projects written in Erlang.


Dependencies
------------

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
============

To install, simply do the following:

..code:: bash

    $ git clone https://github.com/oubiwann/lfe-rackspace.git
    $ cd lfe-rackspace
    $ sudo ERL_LIB=`erl -eval 'io:fwrite(code:lib_dir()), halt().' -noshell` \
          make install


Usage
=====

Add content to me here!

.. Links
.. -----
.. _rebar: https://github.com/rebar/rebar
.. _LFE: https://github.com/rvirding/lfe
.. _Jiffy: https://github.com/davisp/jiffy
.. _lfeunit: https://github.com/lfe/lfeunit
.. _lfe-utils: https://github.com/lfe/lfe-utils
