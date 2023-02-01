Title:<br/>
<b>BINROOT: Function root finding by dichotomy algorithm</b>

Description:<br/>
<p>This program implements the dichotomy algorithm for calculating the root f(x)=0 of a monotonically increasing or decreasing function. Input values are the starting range [A,B], the maximum number of iterations cycles M and the precision DELTA. The purpose of this tutorial is to demonstrate how much more 'serious' programming can be done with Fortran compared to e.g. BASIC, but at the same time how cumbersome coding was back in the '80s when even simple column misalignments caused compilation errors.

Note: User input with READ() may require Ctrl+Enter, not just Enter due to incorrect I/O read of <Enter> as only <LF> (as in Unix).

Warning: In some older versions of Microsoft's Fortran 77, the batch process 'FORT.BAT' assumed that the input filename is given as argument *without* the '.FOR' extension. If it is given, then the output is unpredictable and usually results in a corrupted *original* (source) file! Make sure to always keep backup before compiling - I had to write the source code twice because of this.
