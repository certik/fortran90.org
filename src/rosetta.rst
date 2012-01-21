Python Fortran Rosetta Stone
============================

+---------------------------------------------------+-----------------------+
| NumPy                                             |           Fortran     |
+---------------------------------------------------+-----------------------+
|                                                   |                       |
| ::                                                | ::                    |
|                                                   |                       |
|    from numpy import array, size, min, max, sum   |    real(dp) :: a(3)   |
|    a = array([1, 2, 3])                           |    a = [1, 2, 3]      |
|    print size(a)                                  |    print *, size(a)   |
|    print max(a)                                   |    print *, maxval(a) |
|    print min(a)                                   |    print *, minval(a) |
|    print sum(a)                                   |    print *, sum(a)    |
|                                                   |                       |
+---------------------------------------------------+-----------------------+
