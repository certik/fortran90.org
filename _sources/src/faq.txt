===
FAQ
===

We try to answer here some commonly asked questions about Fortran.
If the answers are subjective or incorrect, please let us know (preferably by
sending a pull request fixing it, see the `main <http://fortran90.org/>`_ page).

What is the advantage of using Fortran (as opposed to for example C/C++)?
-------------------------------------------------------------------------

The Fortran language has been designed with the following goals:

* Contain basic mathematics in the core language (rich array operations,
  complex numbers, exponentiation)

* Be more restricting (and higher level) than languages like C/C++, so that the
  resulting code is easier to maintain and write. There is one canonical way
  to do things and you don’t have to worry about memory allocation (most of
  the times).

* Speed


The key bottom line is: Fortran is *not* a general purpose language.  Rather,
it is built from the ground up to translate mathematics into simple, readable,
and fast code -- straightforwardly maintainable by the gamut of scientists who
actually produce/apply that mathematics. If that is the task at hand, it is the
right tool for the job and, as right tools tend to do, can save enormous time
and pain, with most excellent results in the end. If, however, mathematics is
not the task, then almost certainly C++ will be much, much better.


How to do dynamic dispatch in Fortran (like 'void \*' in C)?
------------------------------------------------------------

The equivalent of ``void *`` in Fortran is ``type(c_ptr)``, see
:ref:`callbacks` for examples of usage.

How to interface Fortran with C and Python?
-------------------------------------------

Just use the ``iso_c_binding`` module to interface with C, see
:ref:`c_interface` for more information and examples.

Once you can call Fortran from C, just write a simple
`Cython <http://cython.org/>`_ wrapper by hand
to call Fortran from Python, see
:ref:`python_interface` for more info.
You can also use `f2py <http://www.f2py.com/>`_ or
`fwrap <http://fwrap.sourceforge.net/>`_.

Does Fortran support closures?
------------------------------

Fortran doesn't support `closures <http://en.wikipedia.org/wiki/Closure_(computer_science)>`_
but it does support nested functions.
See :ref:`nested_functions` for examples of usage.

Are Fortran compilers ABI compatible?
-------------------------------------

Intel C and C++ compilers are
`ABI-compatible <http://software.intel.com/sites/products/collateral/hpc/compilers/intel_linux_compiler_compatibility_with_gnu_compilers.pdf>`_
with GCC and Clang. Fortran compilers in general are not ABI compatible.

What is the best way to distribute and install Fortran libraries?
-----------------------------------------------------------------

Unfortunately it is not as easy as in C/C++ due to the ABI incompatibility
across Fortran compilers. See this
`thread <http://gcc.gnu.org/ml/fortran/2011-06/msg00114.html>`_
for more information.

Does Fortran warn you about undefined symbols?
----------------------------------------------

Yes, it does. For gfortran, you need to use the ``-Wimplicit-interface`` option.

What is the equivalent of the C header files in Fortran?
--------------------------------------------------------

Create a module and use it from other places. The compiler will check all the
types.

What compiler options should I use for development?
---------------------------------------------------

One possibility for gfortran is::

    -Wall -Wextra -Wimplicit-interface -fPIC -Werror -fmax-errors=1 -g -fbounds-check -fcheck-array-temporaries -fbacktrace

This warns about undefined symbols, turns warnings into errors (so that the
compilation stops when undefined symbol is used), stops at the first error,
turns on bounds checks and array temporaries, and turns on backtrace printing
when something fails at runtime (typically accessing an array out of bounds).

What compiler options should I use for production run?
------------------------------------------------------

One possibility for gfortran is::

    -Wall -Wextra -Wimplicit-interface -fPIC -Werror -fmax-errors=1 -O3 -march=native -ffast-math -funroll-loops

This turns off all debugging options (like bounds checks)
and turns on optimizing options (fast math and platform dependent code
generation).

It still warns about undefined symbols, turns warnings into errors (so that the
compilation stops when undefined symbol is used) and stops at the first error.
