Gotchas
=======

Variable Initialization Using Initialization Expression
-------------------------------------------------------

The following code::

    integer :: a = 5

is equivalent to::

    integer, save :: a = 5

and *not* to::

    integer :: a
    a = 5

See for example this `question <http://stackoverflow.com/questions/3352741/fortran-assignment-on-declaration-and-save-attribute-gotcha>`_.
