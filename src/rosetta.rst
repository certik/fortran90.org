Python Fortran Rosetta Stone
============================

+-----------------------------------------------------+--------------------------------------------------------+
| NumPy                                               |           Fortran                                      |
+-----------------------------------------------------+--------------------------------------------------------+
|::                                                   |::                                                      |
|                                                     |                                                        |
| from numpy import array, size, shape, min, max, sum | real(dp) :: a(3)                                       |
| a = array([1, 2, 3])                                | a = [1, 2, 3]                                          |
| print shape(a)                                      | print *, shape(a)                                      |
| print size(a)                                       | print *, size(a)                                       |
| print max(a)                                        | print *, maxval(a)                                     |
| print min(a)                                        | print *, minval(a)                                     |
| print sum(a)                                        | print *, sum(a)                                        |
+-----------------------------------------------------+--------------------------------------------------------+
|::                                                   |::                                                      |
|                                                     |                                                        |
| from numpy import array, size, shape, max, min      | real(dp) :: a(2, 3)                                    |
| a = array([[1, 2, 3], [4, 5, 6]])                   | a = reshape([1, 2, 3, 4, 5, 6], [2, 3])                |
| print shape(a)                                      | print *, shape(a)                                      |
| print size(a, 0)                                    | print *, size(a, 1)                                    |
| print size(a, 1)                                    | print *, size(a, 2)                                    |
| print max(a)                                        | print *, minval(a)                                     |
| print min(a)                                        | print *, maxval(a)                                     |
+-----------------------------------------------------+--------------------------------------------------------+
|::                                                   |::                                                      |
|                                                     |                                                        |
|                                                     | where (evalues < ef - fdtol*kbt)                       |
|                                                     |    eweights = 1._dp                                    |
|                                                     | elsewhere( evalues > ef + fdtol*kbt)                   |
|                                                     |    eweights = 0._dp                                    |
|                                                     | elsewhere                                              |
|                                                     |    eweights = evalues + 1._dp                          |
|                                                     | end where                                              |
+-----------------------------------------------------+--------------------------------------------------------+
|                                                     |::                                                      |
|                                                     |                                                        |
|                                                     | idos = sum(matmul(eweights,kweights))                  |
+-----------------------------------------------------+--------------------------------------------------------+
|                                                     |::                                                      |
|                                                     |                                                        |
|                                                     | integer :: i(3)                                        |
|                                                     | i = [1, 2, 3]                                          |
|                                                     | all(i == [1, 2, 3])                                    |
+-----------------------------------------------------+--------------------------------------------------------+
|::                                                   |::                                                      |
|                                                     |                                                        |
| from numpy import array, shape                      | integer :: x(5, 2)                                     |
| x = array([[1, 6], [2, 7], [3, 8], [4, 9], [5, 10]])| x = reshape([1, 2, 3, 4, 5, 6, 7, 8, 9, 10], shape(x)) |
| print shape(x)                                      | print *, shape(x)                                      |
+-----------------------------------------------------+--------------------------------------------------------+


.. ::   vim: set nowrap textwidth=0 syn=off: ~
