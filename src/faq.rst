===
FAQ
===

We try to answer here some commonly asked questions about Fortran.

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
