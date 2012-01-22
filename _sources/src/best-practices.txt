Fortran Best Practices
======================

This page collects a modern canonical way of doing things in Fortran. It is meant to be short, and it is assumed that you already know how to program in other languages (like Python, C/C++, ...) and also know Fortran syntax a bit. Some things in Fortran are obsolete, so this guide only shows the "one correct/canonical modern way" how to do things.

Summary of the language: http://www.cs.umbc.edu/~squire/fortranclass/summary.shtml

Language features are explained at: http://en.wikipedia.org/wiki/Fortran_language_features

The best resource is a recent Fortran standard, for example the Fortran 2003 standard: http://www.j3-fortran.org/doc/year/04/04-007.pdf

Floating Point Numbers
----------------------

Somewhere create and export a parameter ``dp``::

    integer, parameter:: dp=kind(0.d0)

and declare floats as::

    real(dp) :: a, b, c

Always write all floating point constants as::

    1.0_dp, 3.5_dp, 1.34e8_dp

and never any other way. To print floating point double precision numbers without loosing precision, use the ``(es23.16)`` format (see http://stackoverflow.com/questions/6118231/why-do-i-need-17-significant-digits-and-not-16-to-represent-a-double/).

Integer Division
----------------

Just like in Python 2.x or C, when doing things like ``(N-1)/N`` where ``N`` is an integer and you want a floating point division, force the compiler to use floats at the right hand side, for example by::

    (N - 1.0_dp)/N

As long as one of the ``/`` operands is a float, a floating point division will be used.

Modules and Programs
--------------------

Only use modules and programs. Always setup a module in the following way::

    module ode1d
    use types, only: dp, pi
    use utils, only: stop_error
    implicit none
    private
    public integrate, normalize, parsefunction, get_val, rk4step, eulerstep, &
            rk4step2, get_midpoints, rk4_integrate, rk4_integrate_inward, &
            rk4_integrate_inward2, rk4_integrate3, rk4_integrate4, &
            rk4_integrate_inward4
    
    contains
    
    subroutine get_val(...)
    ...
    end subroutine
    ...
    
    end module

The ``implicit none`` statement works for the whole module (so you don't need to worry about it). By keeping the ``private`` empty, all your subroutines/data types will be private to the module by default. Then you export things by putting it into the ``public`` clause.

Setup programs in the following way::

    program uranium
    use fmesh, only: mesh_exp
    use utils, only: stop_error, dp
    use dft, only: atom
    implicit none
    
    integer, parameter :: Z = 92
    real(dp), parameter :: r_min = 8e-9_dp, r_max = 50.0_dp, a = 1e7_dp
    ...
    print *, "I am running"
    end program

Notice the "explicit imports" (using Python terminology) in the ``use`` statements. You can also use "implicit imports" like::

    use fmesh

But just like in Python, this should be avoided ("explicit is better than implicit") in most cases.

Arrays
------

When passing arrays in and out of a subroutine/function, use the following pattern for 1D arrays::

    subroutine f(r)
    real(dp), intent(in) :: r(:)
    
    integer :: n
    n = size(r)
    do i = 1, n
        r(i) = 1.0_dp / i**2
    enddo
    end subroutine

2D arrays::

    subroutine g(A)
    real(dp), intent(in) :: A(:, :)
    ...
    end subroutine

and call it like this::

    real(dp) :: r(5)
    call f(r)

Always declare the arrays as assume shape (``r(:)``), never any other way. If you want to enforce/check the size of the arrays, put at the beginning of the function::

    if (size(r) != 4) stop "Incorrect size of 'r'"

No array copying is done above. To initialize an array, do::

    integer :: r(5)
    r = [1, 2, 3, 4, 5]

Multidimensional Arrays
-----------------------

Always access slices as ``V(:, 1)``, ``V(:, 2)``, or ``V(:, :, 1)``, e.g. the colons should be on the left. That way the stride is contiguous and it will be fast. So when you need some slice in your algorithm, always setup the array in a way, so that you call it as above. If you put the colon on the right, it will be slow.

Example::

    dydx = matmul(C(:, :, i), y) ! fast
    dydx = matmul(C(i, :, :), y) ! slow

In other words, the "fortran storage order" is: smallest/fastest changing/innermost-loop index first, largest/slowest/outermost-loop index last ("Inner-most are left-most."). So the elements of a 3D array ``A(N1,N2,N3)`` are stored, and thus most efficiently accessed, as::

    do i3 = 1, N3
        do i2 = 1, N2
            do i1 = 1, N1
                A(i1, i2, i3)
            end do
        end do
    end do

Associated array of vectors would then be most efficiently accessed as::

    do i3 = 1, N3
        do i2 = 1, N2
            A(:, i2, i3)
        end do
    end do

And associated set of matrices would be most efficiently accessed as::

    do i3 = 1, N3
        A(:, :, i3)
    end do

Storing/accessing as above then accesses always contiguous blocks of memory, directly adjacent to one another; no skips/strides.

When not sure, always rewrite (in your head) the algorithm to use strides, for example the first loop would become::

    do i3 = 1, N3
        Ai3 = A(:, :, i3)
        do i2 = 1, N2
            Ai2i3 = Ai3(:, i2)
            do i1 = 1, N1
                Ai2i3(i1)
            end do
        end do
    end do

the second loop would become::

    do i3 = 1, N3
        Ai3 = A(:, :, i3)
        do i2 = 1, N2
            Ai3(:, i2)
        end do
    end do

And then make sure that all the strides are always on the left. Then it will be fast.

File Input/Output
-----------------

To read from a file::

    integer :: u
    open(newunit=u, file="log.txt", status="old")
    read(u, *) a, b
    close(u)

Write to a file::

    integer :: u
    open(newunit=u, file="log.txt", status="replace")
    write(u, *) a, b
    close(u)

To append to an existing file::

    integer :: u
    open(newunit=u, file="log.txt", position="append", status="old")
    write(u, *) N, V(N)
    close(u)

The ``newunit`` keyword argument to ``open`` is a Fortran 2008 standard, in older compilers, just replace
``open(newunit=u, ...)`` by::

    open(newunit(u), ...)

where the ``newunit`` function is defined by::

    integer function newunit(unit) result(n)
    ! returns lowest i/o unit number not in use
    integer, intent(out), optional :: unit
    logical inuse
    integer, parameter :: nmin=10   ! avoid lower numbers which are sometimes reserved
    integer, parameter :: nmax=999  ! may be system-dependent
    do n = nmin, nmax
        inquire(unit=n, opened=inuse)
        if (.not. inuse) then
            if (present(unit)) unit=n
            return
        end if
    end do
    call stop_error("newunit ERROR: available unit not found.")
    end function


Interfacing with C
------------------

Write a C wrapper using the ``iso_c_binding`` module::

    module fmesh_wrapper
    
    use iso_c_binding, only: c_double, c_int
    use fmesh, only: mesh_exp
    
    implicit none
    
    contains
    
    subroutine c_mesh_exp(r_min, r_max, a, N, mesh) bind(c)
    real(c_double), intent(in) :: r_min
    real(c_double), intent(in) :: r_max
    real(c_double), intent(in) :: a
    integer(c_int), intent(in) :: N
    real(c_double), intent(out) :: mesh(N)
    call mesh_exp(r_min, r_max, a, N, mesh)
    end subroutine
    
    ! wrap more functions here
    ! ...
    
    end module

You need to declare the length of all arrays (``mesh(N)``) and pass it as a parameter. The Fortran compiler will check that the C and Fortran types match. If it compiles, you can then trust it, and call it from C using the following declaration::

    void c_mesh_exp(double *r_min, double *r_max, double *a, int *N,
            double *mesh);

use it as::

    int N=5;
    double r_min, r_max, a, mesh[N];
    c_mesh_exp(&r_min, &r_max, &a, &N, mesh);

No matter if you are passing arrays in or out, always allocate them in C first, and you are (in C) responsible for the memory management. Use Fortran to fill (or use) your arrays (that you own in C).

If calling the Fortran ``exp_mesh`` subroutine from the ``c_exp_mesh`` subroutine is a problem (CPU efficiency), you can simply implement whatever the routine does directly in the ``c_exp_mesh`` subroutine. In other words, use the ``iso_c_binding`` module as a direct way to call Fortran code from C, and you can make it as fast as needed.

Interfacing with Python
-----------------------

To wrap Fortran code in Python, export it to C first (see above) and then write this Cython code::

    from numpy cimport ndarray
    from numpy import empty
    
    cdef extern:
        void c_mesh_exp(double *r_min, double *r_max, double *a, int *N,
                double *mesh)
    
    def mesh_exp(double r_min, double r_max, double a, int N):
        cdef ndarray[double, mode="c"] mesh = empty(N, dtype="double")
        c_mesh_exp(&r_min, &r_max, &a, &N, &mesh[0])
        return mesh

The memory is allocated and owned (reference counted) by Python, and a pointer is given to the Fortran code. Use this approach for both "in" and "out" arrays.

Notice that we didn't write any C code --- we only told fortran to use the C calling convention when producing the ".o" files, and then we pretended in Cython, that the function is implemented in C, but in fact, it is linked in from Fortran directly. So this is the most direct way of calling Fortran from Python. There is no intermediate step, and no unnecessary processing/wrapping involved.


Type Casting and Callbacks
--------------------------

There are essentially four different wasy to do that, each with its own
advantages and disadvantages.

Work Arrays
~~~~~~~~~~~

Pass a "work array" or two which are packed with everything needed by the
caller and unpacked by the called routine. This is the old way -- e.g., how
LAPACK does it.

General Structure
~~~~~~~~~~~~~~~~~

Define general structure or two which encompass the variations you actually
need (or are even remotely likely to need going forward). This single structure
type or two can then change if needed as future needs/ideas permit but won't
likely need to change from passing, say, real numbers to, say, and
instantiation of a text editor.

There is only so much flexibility really
needed. For example, you could define two structure types for this purpose, one
for Schroedinger and one for Dirac. Each would then be sufficiently general and
contain all the needed pieces with all the right labels.

Point is: it needn't
be "one abstract type to encompass all" or bust. There are natural and viable
options between "all" and "none".

Private Module Variables
~~~~~~~~~~~~~~~~~~~~~~~~

Hide the variable arguments completely by passing in module variables.  However
it is best to avoid such global variables -- even though really just
semi-global -- if possible. But sometimes it may be the simplest cleanest way.
However, with a bit of thought, usually there is a better, safer, more explicit
way along the lines of the previous option "General Structure".

Transfer Intrinsic Function
~~~~~~~~~~~~~~~~~~~~~~~~~~~

Type casting can be done with the ``transfer`` intrinsic function. Examples:

http://jblevins.org/log/transfer

http://jblevins.org/research/generic-list.pdf

http://www.macresearch.org/advanced_fortran_90_callbacks_with_the_transfer_function

In any case, as always, with the advantages of such re-casting, as f90 lets you
do if you really want to, come also the disadvantages that fewer compile- and
run-time checks are possible to catch errors; and with that, inevitably more
leaky, bug-prone code. So one always has to balance the costs and benefits.
Usually, in the context of scientific programming, where the main thrust
represent and solve precise mathematical formulations (as opposed to create a
GUI with some untold number of buttons, drop-downs, and other interface
elements), simplest, least bug-prone, and fastest is to use
one of the first three approaches above.
