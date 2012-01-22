Python Fortran Rosetta Stone
============================

Python with NumPy and Fortran are very similar in terms
of expressiveness and features. This rosetta stone
shows how to implement many common idioms in both languages side by side.


Arrays
------

Arrays are builtin in Fortran, and available in the NumPy module in Python.
The usage is identical, except for the following differences:

    * Fortran counts from 1, NumPy from 0
    * In C the array is stored row wise in the
      memory (by default NumPy uses C storage), while in Fortran it is stored
      column wise (this only matters in the next two points)
    * By default ``reshape`` uses Fortran ordering in Fortran, and C ordering
      in NumPy (in both cases an optional argument ``order`` allows to use the
      other ordering). This also matters when ``reshape`` is used implicitly in
      other operations like flattening.
    * The first index is the fastest in Fortran, while in NumPy, the last index
      is the fastest
    * By default NumPy prints the 2d array nicely, while Fortran flattens it
      (column wise) first (you need to write a subroutine to print a 2D array
      nicely)

Everything else is the same, in particular:

    * There is one-to-one correspondence between NumPy and Fortran array
      operations and things can be expressed
      the same easily/naturally in both languages
    * For 2D arrays, the first index is a row index, the second is the column
      index (just like in mathematics)
    * NumPy and Fortran arrays are equivalent if they have the same shape and
      same elements corresponding to the same index (it doesn't matter what the
      internal memory storage is)
    * Any array expression involving mathematical functions is allowed, for
      example ``a**2 + 2*a + exp(a)``, ``sin(a)``, ``a * b`` and
      ``a + b`` (it operates element wise)
    * You need to use a function to multiply two matrices using matrix
      multiplication
    * Advanced indexing/slicing
    * Arrays can be of any integer, real or complex type
    * ...


+------------------------------------------------------+--------------------------------------------------------+
| NumPy                                                |           Fortran                                      |
+------------------------------------------------------+--------------------------------------------------------+
|::                                                    |::                                                      |
|                                                      |                                                        |
| from numpy import array, size, shape, min, max, sum  | integer :: a(3)                                        |
| a = array([1, 2, 3])                                 | a = [1, 2, 3]                                          |
| print shape(a)                                       | print *, shape(a)                                      |
| print size(a)                                        | print *, size(a)                                       |
| print max(a)                                         | print *, maxval(a)                                     |
| print min(a)                                         | print *, minval(a)                                     |
| print sum(a)                                         | print *, sum(a)                                        |
+------------------------------------------------------+--------------------------------------------------------+
|::                                                    |::                                                      |
|                                                      |                                                        |
| from numpy import reshape                            | integer :: a(2, 3), b(2, 3)                            |
| a = reshape([1, 2, 3, 4, 5, 6], (2, 3))              | a = reshape([1, 2, 3, 4, 5, 6], [2, 3], order=[2, 1])  |
| b = reshape([1, 2, 3, 4, 5, 6], (2, 3), order="F")   | b = reshape([1, 2, 3, 4, 5, 6], [2, 3])                |
| print a[0, :]                                        | print *, a(1, :)                                       |
| print a[1, :]                                        | print *, a(2, :)                                       |
| print                                                | print *                                                |
| print b[0, :]                                        | print *, b(1, :)                                       |
| print b[1, :]                                        | print *, b(2, :)                                       |
|                                                      |                                                        |
|Output::                                              |Output::                                                |
|                                                      |                                                        |
| [1 2 3]                                              |            1           2           3                   |
| [4 5 6]                                              |            4           5           6                   |
|                                                      |                                                        |
| [1 3 5]                                              |            1           3           5                   |
| [2 4 6]                                              |            2           4           6                   |
+------------------------------------------------------+--------------------------------------------------------+
|::                                                    |::                                                      |
|                                                      |                                                        |
| from numpy import array, size, shape, max, min       | integer :: a(2, 3)                                     |
| a = array([[1, 2, 3], [4, 5, 6]])                    | a = reshape([1, 2, 3, 4, 5, 6], [2, 3], order=[2, 1])) |
| print shape(a)                                       | print *, shape(a)                                      |
| print size(a, 0)                                     | print *, size(a, 1)                                    |
| print size(a, 1)                                     | print *, size(a, 2)                                    |
| print max(a)                                         | print *, maxval(a)                                     |
| print min(a)                                         | print *, minval(a)                                     |
| print a[0, 0], a[0, 1], a[0, 2]                      | print *, a(1, 1), a(1, 2), a(1, 3)                     |
| print a[1, 0], a[1, 1], a[1, 2]                      | print *, a(2, 1), a(2, 2), a(2, 3)                     |
| print a                                              | print *, a                                             |
|                                                      |                                                        |
|Output::                                              |Output (whitespace trimmed)::                           |
|                                                      |                                                        |
| (2, 3)                                               | 2 3                                                    |
| 2                                                    | 2                                                      |
| 3                                                    | 3                                                      |
| 6                                                    | 6                                                      |
| 1                                                    | 1                                                      |
| 1 2 3                                                | 1 2 3                                                  |
| 4 5 6                                                | 4 5 6                                                  |
| [[1 2 3]                                             | 1 4 2 5 3 6                                            |
|  [4 5 6]]                                            |                                                        |
+------------------------------------------------------+--------------------------------------------------------+
|::                                                    |::                                                      |
|                                                      |                                                        |
| from numpy import array, all, any                    | integer :: i(3)                                        |
| i = array([1, 2, 3])                                 | i = [1, 2, 3]                                          |
| all(i == [1, 2, 3])                                  | all(i == [1, 2, 3])                                    |
| any(i == [2, 2, 3])                                  | any(i == [2, 2, 3])                                    |
+------------------------------------------------------+--------------------------------------------------------+
|::                                                    |::                                                      |
|                                                      |                                                        |
| from numpy import array, empty                       | integer :: a(10), b(10)                                |
| a = array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])           | a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]                    |
| b = empty(10)                                        | where (a > 5)                                          |
| b[:] = 0                                             |     b = a - 3                                          |
| b[a > 2] = 1                                         | elsewhere (a > 2)                                      |
| b[a > 5] = a[a > 5] - 3                              |     b = 1                                              |
|                                                      | elsewhere                                              |
|                                                      |     b = 0                                              |
|                                                      | end where                                              |
+------------------------------------------------------+--------------------------------------------------------+
|::                                                    |::                                                      |
|                                                      |                                                        |
| from numpy import array, empty                       | integer :: a(10), b(10)                                |
| a = array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])           | a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]                    |
| b = empty(10)                                        | where (a > 5)                                          |
| for i in range(len(a)):                              |     b = a - 3                                          |
|     if a[i] > 5:                                     | elsewhere (a > 2)                                      |
|         b[i] = a[i] - 3                              |     b = 1                                              |
|     elif a[i] > 2:                                   | elsewhere                                              |
|         b[i] = 1                                     |     b = 0                                              |
|     else:                                            | end where                                              |
|         b[i] = 0                                     |                                                        |
+------------------------------------------------------+--------------------------------------------------------+
|::                                                    |::                                                      |
|                                                      |                                                        |
| from numpy import array, sum, ones, size             | integer :: a(10)                                       |
| a = array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])           | a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]                    |
| print sum(a)                                         | print *, sum(a)                                        |
| print sum(a[(a > 2) & (a < 6)])                      | print *, sum(a, mask=a > 2 .and. a < 6)                |
| o = ones(size(a), dtype="int")                       | print *, count(a > 2 .and. a < 6)                      |
| print sum(o[(a > 2) & (a < 6)])                      |                                                        |
+------------------------------------------------------+--------------------------------------------------------+
|::                                                    |::                                                      |
|                                                      |                                                        |
| from numpy import array, dot                         | integer :: a(2, 2), b(2, 2)                            |
| a = array([[1, 2], [3, 4]])                          | a = reshape([1, 2, 3, 4], [2, 2], order=[2, 1])        |
| b = array([[2, 3], [4, 5]])                          | b = reshape([2, 3, 4, 5], [2, 2], order=[2, 1])        |
| print a * b                                          | print *, a * b                                         |
| print dot(a, b)                                      | print *, matmul(a, b)                                  |
|                                                      |                                                        |
|Output::                                              |Output::                                                |
|                                                      |                                                        |
| [[ 2  6]                                             |            2          12           6          20       |
|  [12 20]]                                            |           10          22          13          29       |
| [[10 13]                                             |                                                        |
|  [22 29]]                                            |                                                        |
+------------------------------------------------------+--------------------------------------------------------+


Modules
-------

Fortran modules work just like Python modules. Differences:

    * Fortran modules cannot be nested
    * One can specify private module symbols in Fortran

Identical features:

    * A module contains variables, types and functions/subroutines
    * By default all variables/types/functions can be accessed from other
      modules, but one can change this by explicitly specifying which symbols
      are private or public (in Python this only works for implicit imports)
    * Symbols that are public don't pollute the global namespace, but need
      to be explicitly imported from the module in order to use them
    * One can use explicit or implicit imports (explicit imports are
      recommended)

One creates the module:

+------------------------------------------------------+--------------------------------------------------------+
| Python                                               |           Fortran                                      |
+------------------------------------------------------+--------------------------------------------------------+
|File ``a.py``::                                       |File ``a.f90``::                                        |
|                                                      |                                                        |
| i = 5                                                | module a                                               |
|                                                      | implicit none                                          |
| def f(x):                                            |                                                        |
|     return x + 5                                     | integer :: i = 5                                       |
|                                                      |                                                        |
| def g(x):                                            | contains                                               |
|     return x - 5                                     |                                                        |
|                                                      | integer function f(x) result(r)                        |
|                                                      | integer, intent(in) :: x                               |
|                                                      | r = x + 5                                              |
|                                                      | end function                                           |
|                                                      |                                                        |
|                                                      | integer function g(x) result(r)                        |
|                                                      | integer, intent(in) :: x                               |
|                                                      | r = x - 5                                              |
|                                                      | end function                                           |
|                                                      |                                                        |
|                                                      | end module                                             |
+------------------------------------------------------+--------------------------------------------------------+

And uses it from the main program as follows:

+------------------------------------------------------+--------------------------------------------------------+
| Python                                               |           Fortran                                      |
+------------------------------------------------------+--------------------------------------------------------+
|File ``main.py``::                                    |File ``main.f90``::                                     |
|                                                      |                                                        |
| from a import f, i                                   | program main                                           |
|                                                      | use a, only: f, i                                      |
| print f(3)                                           | implicit none                                          |
| print i                                              | print *, f(3)                                          |
|                                                      | print *, i                                             |
|                                                      | end program                                            |
|                                                      |                                                        |
|Output::                                              |Output::                                                |
|                                                      |                                                        |
| 8                                                    | 8                                                      |
| 5                                                    | 5                                                      |
+------------------------------------------------------+--------------------------------------------------------+


In order to specify which symbols are public and private, one would use:

+------------------------------------------------------+--------------------------------------------------------+
| Python                                               |           Fortran                                      |
+------------------------------------------------------+--------------------------------------------------------+
|File ``a.py``::                                       |File ``a.f90``::                                        |
|                                                      |                                                        |
| __all__ = ["i", "f"]                                 | module a                                               |
|                                                      | implicit none                                          |
| i = 5                                                | private                                                |
|                                                      | public i, f                                            |
| def f(x):                                            |                                                        |
|     return x + 5                                     | integer :: i = 5                                       |
|                                                      |                                                        |
| def g(x):                                            | contains                                               |
|     return x - 5                                     |                                                        |
|                                                      | integer function f(x) result(r)                        |
|                                                      | integer, intent(in) :: x                               |
|                                                      | r = x + 5                                              |
|                                                      | end function                                           |
|                                                      |                                                        |
|                                                      | integer function g(x) result(r)                        |
|                                                      | integer, intent(in) :: x                               |
|                                                      | r = x - 5                                              |
|                                                      | end function                                           |
|                                                      |                                                        |
|                                                      | end module                                             |
+------------------------------------------------------+--------------------------------------------------------+

There is a difference though. In Fortran, the symbol ``g`` will be private (not
possible to import from other modules no matter if we use explicit or implicit
import), ``f`` and ``i`` public. In Python, when implicit import is used, the
symbol ``g`` will not be imported, but when explicit import is used, the
symbols ``g`` can still be imported.

Floating Point Numbers
----------------------

Both NumPy and Fortran can work with any specified precision and
if no precision is specified, then the default platform precision is used.

In Python, the default precision is typically double precision,
while in Fortran it is single precision.
See also the relevant
`Python <http://docs.python.org/tutorial/floatingpoint.html>`_
and `NumPy <http://docs.scipy.org/doc/numpy/user/basics.types.html>`_
documentation.

+------------------------------------------------------+--------------------------------------------------------+
| Python 2.x                                           |           Fortran                                      |
+------------------------------------------------------+--------------------------------------------------------+
|Single precision::                                    |Single precision::                                      |
|                                                      |                                                        |
| from numpy import float32                            | real :: f                                              |
| f = float32(1.1)                                     | f = 1.1                                                |
+------------------------------------------------------+--------------------------------------------------------+
|Double precision::                                    |Double precision::                                      |
|                                                      |                                                        |
| f = 1.1            # 1.1                             | integer, parameter :: dp=kind(0.d0)                    |
| f = 1e8            # 100000000.0                     | real(dp) :: f                                          |
| f = float(1) / 2   # 0.5                             | f = 1.1_dp             ! 1.1                           |
| f = float(1 / 2)   # 0.0                             | f = 1e8_dp             ! 100000000.0                   |
| f = float(5)       # 5.0                             | f = real(1, dp) / 2    ! 0.5                           |
|                                                      | f = 1 / 2              ! 0.0                           |
|                                                      | f = 5                  ! 5.0                           |
+------------------------------------------------------+--------------------------------------------------------+

In Fortran the habit is to always specify the precision using
the ``_dp`` suffix, where ``dp`` is defined
in the ``types.f90`` module below as
``integer, parameter :: dp=kind(0.d0)`` (so that one can change
the precision at one place if needed). If no precision is specified,
then single precision is used (and as such, this leads to single/double
corruption), so one *always* needs to specify the precision.

In all
Fortran code snippets below, it is assumed, that you did
``use types, only: dp``. The ``types.f90`` module is::

    module types
    implicit none
    private
    public dp, hp
    integer, parameter :: dp=kind(0.d0), &          ! double precision
                          hp=selected_real_kind(15) ! high precision
    end module

Math and Complex Numbers
------------------------

Fortran has builtin mathematical functions, in Python one has to import them
from the ``math`` module or (for the more advanced functions) from the SciPy
package. Fortran doesn't include constants, so one has to use the
``constants.f90`` module (included below).

Otherwise the usage is identical.

+------------------------------------------------------+--------------------------------------------------------+
| Python                                               |           Fortran                                      |
+------------------------------------------------------+--------------------------------------------------------+
|::                                                    |::                                                      |
|                                                      |                                                        |
| from math import cos, pi, e                          | use constants, only: pi, e                             |
| I = 1j                                               | complex(dp) :: I = (0, 1)                              |
| print e**(I*pi) + 1                                  | print *, e**(I*pi) + 1                                 |
| print cos(pi)                                        | print *, cos(pi)                                       |
| print 4 + 5j                                         | print *, (4, 5)                                        |
| print 4 + 5*I                                        | print *, 4 + 5*I                                       |
|                                                      |                                                        |
|Output::                                              |Output::                                                |
|                                                      |                                                        |
| 1.22460635382e-16j                                   |  (  0.0000000000000000     , 1.22460635382237726E-016) |
| -1.0                                                 |   -1.0000000000000000                                  |
| (4+5j)                                               |  (  4.0000000    ,  5.0000000    )                     |
| (4+5j)                                               |  (  4.0000000000000000     ,  5.0000000000000000     ) |
+------------------------------------------------------+--------------------------------------------------------+

Fortran module ``constants.f90``::

    module constants
    use types, only: dp
    implicit none
    private
    public pi, e, I
    ! Constants contain more digits than double precision, so that
    ! they are rounded correctly:
    real(dp), parameter :: pi   = 3.1415926535897932384626433832795_dp
    real(dp), parameter :: e    = 2.7182818284590452353602874713527_dp
    complex(dp), parameter :: I = (0, 1)
    end module

Strings and Formatting
----------------------

The functionality of both Python and Fortran is pretty much equivalent,
only the syntax is a litte different.

In both Python and Fortran, strings can be delimited by either ``"``
or `````.

There are three general ways to print formatted strings:

+-----------------------------------------------------------+----------------------------------------------------------------------+
| Python                                                    |           Fortran                                                    |
+-----------------------------------------------------------+----------------------------------------------------------------------+
|::                                                         |::                                                                    |
|                                                           |                                                                      |
| print "Integer", 5, "and float", 5.5, "works fine."       | use utils, only: str                                                 |
| print "Integer " + str(5) + " and float " + str(5.5) + "."| print *, "Integer", 5, "and float", 5.5, "works fine."               |
| print "Integer %d and float %f." % (5, 5.5)               | print *, "Integer " // str(5) // " and float " // str(5.5_dp) // "." |
|                                                           | print '("Integer ", i0, " and float ", f0.6, ".")', 5, 5.5           |
|                                                           |                                                                      |
|Output::                                                   |Output::                                                              |
|                                                           |                                                                      |
| Integer 5 and float 5.5 works fine.                       |  Integer           5 and float   5.5000000     works fine.           |
| Integer 5 and float 5.5.                                  |  Integer 5 and float 5.500000.                                       |
| Integer 5 and float 5.500000.                             | Integer 5 and float 5.500000.                                        |
+-----------------------------------------------------------+----------------------------------------------------------------------+

And here are some of the frequently used formats:

+-----------------------------------------------------------+----------------------------------------------------------------------+
| Python                                                    |           Fortran                                                    |
+-----------------------------------------------------------+----------------------------------------------------------------------+
|::                                                         |::                                                                    |
|                                                           |                                                                      |
| print "%3d" % 5                                           | print '(i3)', 5                                                      |
| print "%03d" % 5                                          | print '(i3.3)', 5                                                    |
| print "%s" % "text"                                       | print '(a)', "text"                                                  |
| print "%15.7f" % 5.5                                      | print '(f15.7)', 5.5_dp                                              |
| print "%23.16e" % -5.5                                    | print '(es23.16)', -5.5_dp                                           |
|                                                           |                                                                      |
|Output::                                                   |Output::                                                              |
|                                                           |                                                                      |
|   5                                                       |   5                                                                  |
| 005                                                       | 005                                                                  |
| text                                                      | text                                                                 |
|       5.5000000                                           |       5.5000000                                                      |
| -5.5000000000000000e+00                                   | -5.5000000000000000E+00                                              |
|                                                           |                                                                      |
+-----------------------------------------------------------+----------------------------------------------------------------------+


.. ::   vim: set nowrap textwidth=0 syn=off: ~
