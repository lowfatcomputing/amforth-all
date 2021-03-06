
Efficient RAM Usage
===================

RAM is probably the scarcest resource
of an atmega. To make the best of it, some
additional words may be helpful.

cvariable
---------

:command:`cvariable` acts like :command:`variable` but
does not allocate a cell (2 bytes) but only 1 byte
of RAM. Access to it is limited to :command:`c@` and
:command:`c!`. To indicate the size, one may want to
use the `Hungarian Notation <http://en.wikipedia.org/wiki/Hungarian_notation>`_.

There are a few possible implementations. One uses carnal
knowledge of the inner workings, the other one relies
on the fact that 1 cell is 2 bytes RAM in amforth.

.. code-block:: forth

 : cvariable
    here constant 1 allot ; \ carnal knowledge

 \ just a variable, but gives one byte RAM back to pool
 \ : cvariable variable -1 allot ;

Use of such small variables is just like other ones:

.. code-block:: forth

  answer cvariable \ allocates 1 byte only!
  42 answer c!
  answer c@ .

  \ troublesome
  answer @ .    \ undetermined
  4242 answer ! \ destroys other data

.. seealso:: :ref:`Arrays`

cvalue
------

Value is targeted to the EEPROM usage pattern: Write seldom,
read often. The underlying implementation can use different
memories as well. The following example illustrates this with
an implementation of a value that stores a single byte:

.. code-block:: forth

   : cvalue ( n "name" -- )
     (create) reveal   \ create a new wordlist entry
     postpone (value)  \ the runtime action
     here ,            \ the address for the methods
     postpone c@       \ method for the read operation
     postpone c!       \ method for the write (TO) operation
     here 1 allot c!   \ allocate the memory and initialize it
   ;


Using this new value is straight forward:

.. code-block:: none

   > 17 cvalue answer
   ok
   > answer .
   17 ok
   > 42 to answer
   ok
   > answer .
   42 ok
   >

After definition the new size restricted value is used like any other value.
To read it, simply call its name. To write to it, use the TO operation.
Note that the :command:`to` is the same as for the standard (eeprom) value's.
It is also save against overflows:

.. code-block:: none

   > $dead to answer
   ok
   > hex answer .
   AD ok
   >

.. note:: :command:`cvalue` requires amforth version 5.1 since :command:`reveal`
          is not available in earlier versions.
