Iterative Hough Transform for 3D Line Detection
===============================================

This code implements the algorithm described in (cited as "IPOL paper" below):

> C. Dalitz, T. Schramke, M. Jeltsch: "Iterative Hough Transform for
> Line Detection in 3D Point Clouds." Image Processing On Line 7 (2017),
> pp. 184–196. https://doi.org/10.5201/ipol.2017.208

Please cite this article when using the code. The article was published
on IPOL with version 1.1 of this code. For changes since then, see the file
*CHANGES*.


Source Files
------------

- `hough3dlines.cpp`  
  Main program that implements Algorithm 1 (Iterative Hough Transform)
  of the IPOL paper

- `hough.[h|cpp]`  
  Class implementing Algorithm 2 (Hough Transform) of the IPOL paper

- `sphere.[h|cpp]`  
  Class implementating the direction discretization as described in
  section 2.2 of the IPOL paper

- `vector3d.[h|cpp]`  
   Class for a 3D point with common math operations

- `pointcloud.[h|cpp]`  
  Class for a set of 3D points


Installation
------------

The source code is written in C++ and thus requires a C++ compiler.
Moreover, it needs the external library libeigen 3.x, available from
http://eigen.tuxfamily.org/.

For compilation with the provided Makefile, three adaptions to your
environment might be necessary:

 - set CC to your C++ compiler
 - set LIBEIGEN to the path to your libeigen headers

To compile the program, simply type "make". To test it on the test data,
type "make test".


Usage
-----

*hough3dlines* without any or with an unknown option (e.g. "-?") will print
the following usage message:

    Usage:
        hough3dlines [options] <infile>
    Options (defaults in brackets):
        -o <outfile>   write results to <outfile> [stdout]
        -dx <dx>       step width in x'y'-plane [0]
                       when <dx>=0, it is set to 1/64 of total width
        -nlines <nl>   maximum number of lines returned [0]
                       when <nl>=0, all lines are returned
        -minvotes <nv> only lines with at least <nv> points are returned [0]
        -gnuplot       print result as a gnuplot command
        -raw           print plot data in easily machine-parsable format
        -delim <char>  use <char> as field delimiter in input file [,]
        -v             be verbose and print Hough space size to stdout
        -vv            be even more verbose and print Hough lines (before LSQ)


Input
-----

The input format is described in section 5 of the IPOL paper.
The input file must contain the point coordinates, one point per line
with x,y, and z separated by commas. Lines starting with a hash (#)
are ignored. Example:

    # point cloud data from a wondrous experiment
    41.7201,138.2140,-648.0000
    0.0001,-138.2140,-440.0000
    2.4543,-136.8650,-436.8000

The delimiter (comma) can be cchanged with the command line option "-delim".


Output
------

The output is printed to stdout unless it is redirected to a file with
the option "-o". The standard output format is described in section 5
of the IPOL paper. It lists the detected lines one per line with the
number of points and the parameters a and b, as in the following example:

    npoints=58, a=(2.5682,-123.8986,0.3456), b=(0.0000,0.7071,0.7071)
    npoints=32, a=(-2.4576,34.8665,0.0000), b=(0.7071,0.0000,0.7071)
    npoints=3, a=(7.0056,-12.7867,8.5634), b=(0.5773,0.5773,0.5773)

There are two other optional output formats that can be useful for
visualization of the result:

 1) The option "-gnuplot" can be used to immediately visualize the result by
    piping the program output to gnuplot, as in the following example:

      hough3dlines testdata.dat -dx 0.4 -gnuplot | gnuplot -persist

 2) The option "-raw" prints the plot data in an easily machine-readable
    format as space separated values that can be used to automatically
    construct a plotting comand. The numbers have the following meaning:

      minX maxX minY maxY minZ maxZ
      paramMin paramMax
      aX aY aZ bX bY bZ npoints

where the first line specifies the point cloud bounding box, the
second line the range of t values in the line parametrization a + t*b,
and the following lines list the line parameters with one line per line.


Authors & Copyright
-------------------

Christoph Dalitz, 2017-2020, <https://lionel.kr.hsnr.de/~dalitz/>  
Tilman Schramke, Manuel Jeltsch, 2017  
Institute for Pattern Recognition, Niederrhein University of Applied Sciences,
Krefeld, Germany


License
-------

This code is provided under a BSD-style license.
See the file LICENSE for details.
