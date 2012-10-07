Gotchas
=======

.. highlight:: fortran

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

.. _floating_point_numbers_gotcha:

Floating Point Numbers
----------------------

Assuming the definitions::

    integer, parameter :: dp=kind(0.d0)           ! double precision
    integer, parameter :: sp=kind(0.0 )           ! single precision

Then the following code::

    real(dp) :: a
    a = 1.0

is equivalent to::

    real(dp) :: a
    a = 1.0_sp

and *not* to::

    real(dp) :: a
    a = 1.0_dp

As such, always use the ``_dp`` suffix as explained in
:ref:`floating_point_numbers`. However, the following code::

    real(dp) :: a
    a = 1

is equivalent to::

    real(dp) :: a
    a = 1.0_dp

And so it is safe to assign integers to floating point numbers without loosing
any accuracy (but one must be careful about integer division, e.g.  ``1/2`` is
equal to ``0`` and not ``0.5``).
