Python Fortran Rosetta Stone
============================

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
| from numpy import array, size, shape, max, min       | integer :: a(2, 3)                                     |
| a = array([[1, 2, 3], [4, 5, 6]])                    | a = transpose(reshape([1, 2, 3, 4, 5, 6], [3, 2]))     |
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
| from numpy import array, sum, logical_and, ones, size| integer :: a(10)                                       |
| a = array([1, 2, 3, 4, 5, 6, 7, 8, 9, 10])           | a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]                    |
| print sum(a)                                         | print *, sum(a)                                        |
| print sum(a[logical_and(a > 2, a < 6)])              | print *, sum(a, mask=a > 2 .and. a < 6)                |
| o = ones(size(a), dtype="int")                       | print *, count(a > 2 .and. a < 6)                      |
| print sum(o[logical_and(a > 2, a < 6)])              |                                                        |
|                                                      |                                                        |
|                                                      |                                                        |
|                                                      |                                                        |
|                                                      |                                                        |
|                                                      |                                                        |
|                                                      |                                                        |
+------------------------------------------------------+--------------------------------------------------------+
|::                                                    |::                                                      |
|                                                      |                                                        |
| from numpy import array, dot                         | integer :: a(2, 2), b(2, 2)                            |
| a = array([[1, 2], [3, 4]])                          | a = reshape([1, 3, 2, 4], [2, 2])                      |
| b = array([[2, 3], [4, 5]])                          | b = reshape([2, 4, 3, 5], [2, 2])                      |
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


.. ::   vim: set nowrap textwidth=0 syn=off: ~
