===
FAQ
===

We try to answer here some commonly asked questions about Fortran.
If the answers are subjective or incorrect, please let us know (preferably by
sending a pull request fixing it, see the `main <http://fortran90.org/>`_ page).

What is the advantage of using Fortran (as opposed to for example C/C++)?
-------------------------------------------------------------------------

Fortran is built from the ground up to translate mathematics into simple,
readable, and fast code – straightforwardly maintainable by the gamut of
mathematicians, scientists, and engineers who actually produce/apply that
mathematics. If that is the task at hand, it is the right tool for the job and,
as right tools tend to do, can save enormous time and pain, with most excellent
results. If, however, mathematics is not the main task, then almost certainly
C/C++, or a host of other more general-purpose languages, will be much better.

The design goals of the C++ language are
(`citing <http://www2.research.att.com/~bs/C++0xFAQ.html#aims>`_
Bjarne Stroustrup talking about the aims of the C++0x
standard): *Make C++ a better language for systems programming and library
building -- that is, to build directly on C++'s contributions to
programming, rather than providing specialized facilities for a
particular sub-community (e.g. numeric computation or Windows-style
application development).*
(See also the `specific aims
<http://www2.research.att.com/~bs/C++0xFAQ.html#specific-aims>`_.)

On the other hand,
the Fortran language has been designed with the following goals
(see for example the review article
`The Seven Ages of Fortran <http://journal.info.unlp.edu.ar/journal/journal30/papers/JCST-Apr11-1.pdf>`_
by Michael Metcalf):

* Contain basic mathematics in the core language (rich array operations,
  complex numbers, exponentiation, special functions)

* Be more restricting (and higher level) than languages like C/C++, so that the
  resulting code is easier to maintain and write and easier for the compilers
  to optimize (e.g. pointers are purposely restricted so that they can be more
  highly optimized than C pointers, Fortran arrays are designed in such a way
  that compilers can check for size and shape mismatches at compile time and
  index errors at run time, etc...). There is one canonical way to do things and
  you don’t have to worry about memory allocation (most of the times).

* Speed


An important point is that having all the basic elements in the language itself
greatly simplifies both writing and reading fast, robust code. Writing and
reading is simplified because there is a single standard set of
functions/constructs. No need to wonder what class the array operations are
coming from, what the member functions are, how well it will be maintained in 5
years, how well optimized it is/will be, etc. All the basics are in the
language itself: fast, robust, and standard for all to read and write -- and
for the compiler writers to optimize at the machine level.


What are good books to learn Fortran from?
------------------------------------------

We have found,
`Metcalf, Reid, & Cohen: Modern Fortran Explained
<http://www.amazon.com/Explained-Numerical-Mathematics-Scientific-Computation/dp/0199601429>`_,
to be quite helpful in providing both the larger context of the language as a
whole and a clear, well-connected presentation, organized by standard: f95,
f2003, and f2008.

Other books can be found for example at
`fortran.com/metcalf.htm <http://www.fortran.com/metcalf.htm>`_

However, Fortran is relatively quick to learn because it is so much simpler
and smaller than C/C++ (in practice, that is, with all needed libraries
included).

What are other good online Fortran resources?
---------------------------------------------

We have found the following links to be quite helpful:

http://en.wikipedia.org/wiki/Fortran

http://en.wikipedia.org/wiki/Fortran_language_features

http://fortranwiki.org/

http://www.fortran.com/metcalf.htm

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

No. Fortran doesn't support
`closures <http://en.wikipedia.org/wiki/Closure_(computer_science)>`_.

Does Fortran support nested functions?
--------------------------------------

Yes, see :ref:`nested_functions` for examples of usage.

How to implement functions that operate on arbitrary shape arrays?
------------------------------------------------------------------

You can use the ``elemental`` keyword to implement subroutines/functions that
can operate on arrays of any shape. Other approaches are to use ``reshape`` or
explicit-shape arrays. See :ref:`elemental` for examples of usage of both
approaches.


.. _ABI:

Are Fortran compilers ABI compatible?
-------------------------------------

No, in general Fortran compilers are not ABI compatible.
Things that are different:

* Run-time library: different for each compiler. For the given compiler,
  most of the time the library is backward compatible (for example
  libgfortran of GCC 4.7 is compatible with 4.6, 4.5, 4.4 and 4.3; 4.5 is
  compatible with 4.4 and 4.3. But 4.2 has a different .so version and is
  incompatible with either 4.1 and 4.3.)
* Modules: convention for naming and symbol mangling
* Trailing underscores (zero, one (most common), two)
* Calling convention: Whether real is passed as double, whether
  a function returns the value as first argument, etc. (see for
  example the ``-ff2c`` option in gfortran)
* Logical: Special Intel vs. gfortran problem: Intel has ``-1`` as
  ``.true.`` and gfortran ``1``. With higher optimization levels,
  gfortran only looks at one bit, hence ``-1`` is ``.false.``.
* ...

On the other hand, Intel C and C++ compilers are
`ABI-compatible <http://software.intel.com/sites/products/collateral/hpc/compilers/intel_linux_compiler_compatibility_with_gnu_compilers.pdf>`_
with GCC and Clang.

.. _distribute_libraries:

What is the best way to distribute and install Fortran libraries?
-----------------------------------------------------------------

The best way is to simply provide the library as modules with source. That way,
compilers can optimize to the particular hardware and there are no object-file
incompatibility issues -- and the user can extend/modify the module for his own
purposes.

Due to ABI incompatibility, in general the ``.so``/``.a`` libraries compiled
with one compiler version cannot be used with any other compiler or version.

As such, the only two options are:

1.  Distribute different ``.so``/``.a`` for each compiler (to some extent,
    they can be used with different versions of the same compiler, see
    :ref:`ABI`).

    This means to either provide source code and the user compiles it using
    his compiler, or precompile it with each compiler version (for commercial
    libraries). Either way, once we have ``.so``/``.a`` compatible with our
    compiler, there are generally two ways to call it from a program:

        1.1. Distribute ``.mod`` files, that are compiler version dependent (In
        case of gfortran, they are only compatible between releases (4.5.0 and
        4.5.2) but not between minor versions (4.5 vs 4.6))

        1.2. Distribute interface ``.f90`` files, that contain the "abstract
        interface" for each subroutine/function, those are compiler
        independent, but they don't work for modules. The upcoming Fortran
        standard for "submodules" will make this work for modules as well.

2.  Provide C interface (see :ref:`c_interface`) and distribute just one
    ``.so``/``.a``.

    The library would be indistinguishable from any other C
    library, and it would be used from Fortran like any other C library. This of
    course means that one cannot use Fortran features not available through the C
    interface (currently: assume shape arrays, allocatable arrays, pointer arrays,
    but those will all be eventually available in future Fortran standards).


Unless the ABI becomes compatible across compilers, the easiest
is to use 1.1. for Fortran usage, and 2. for C/Python usage.
(If the ABI became compatible let's say at least between ifort and gfortran,
it might make sense to use 1.2. and distribute only one ``.so``/``.a``).

Note I: Distributing the ``.a`` file only (as opposed to both ``.so`` and
``.a`` files) for the given platform/compiler should be enough in many cases as
it is faster and the number of programs sharing the library on any given system
is typically fairly low.

Note II: The advantage of distributing the sources is that it allows to
optimize for the system at hand (e.g. GCC's ``-march=native`` option), as well
as for more specialized machines like BlueGene.

See this
`thread <http://gcc.gnu.org/ml/fortran/2011-06/msg00114.html>`_
for more information.

Does Fortran warn you about undefined symbols?
----------------------------------------------

Yes, it does. For gfortran, you need to use the ``-Wimplicit-interface`` option.

What is the equivalent of the C header files in Fortran?
--------------------------------------------------------

Create a module and use it from other places
(see :ref:`modules` for more information). The compiler will check all the
types. However, there is a difference from C in how to distribute Fortran
libraries, see :ref:`distribute_libraries` for more information.

What compiler options should I use for development?
---------------------------------------------------

One possibility for gfortran is::

    -Wall -Wextra -Wimplicit-interface -fPIC -Werror -fmax-errors=1 -g -fbounds-check -fcheck-array-temporaries -fbacktrace

With gfortran 4.5 and newer, you can use ``fcheck=all``, which turns
on ``-fbounds-check -fcheck-array-temporaries`` and other checks.

This warns about undefined symbols, turns warnings into errors (so that the
compilation stops when undefined symbol is used), stops at the first error,
turns on bounds checks and array temporaries, and turns on backtrace printing
when something fails at runtime (typically accessing an array out of bounds).

For Intel ifort::

    -warn all -check all

What compiler options should I use for production run?
------------------------------------------------------

One possibility for gfortran is::

    -Wall -Wextra -Wimplicit-interface -fPIC -Werror -fmax-errors=1 -O3 -march=native -ffast-math -funroll-loops

This turns off all debugging options (like bounds checks)
and turns on optimizing options (fast math and platform dependent code
generation).

It still warns about undefined symbols, turns warnings into errors (so that the
compilation stops when undefined symbol is used) and stops at the first error.

For Intel ifort::

    -warn all -fast

