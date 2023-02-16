Title:<br/>
<b>EPSILON: Floating-point 'epsilon' estimation in Fortran</b>

Description:<br/>
<p>This program implements floating-point 'epsilon' estimation in retro Fortran no-talking, in emulated 80286 / MS-DOS machine in DOSbox. This very short code demonstrates how easy it is to get the actual FP accuracy, i.e., the significant decimal digits in FP arithmetic operations. The result in Fortran 77 is seven FP digits for REAL type and 15 digits for DOUBLE PRECISION type, which are consistent with 2-byte and 4-byte float types, correspondingly, used in other programming languages of that era like C.

Warning: In some older versions of Microsoft's Fortran 77, the batch process 'FORT.BAT' assumed that the input filename is given as argument *without* the '.FOR' extension. If it is given, then the output is unpredictable and usually results in a corrupted *original* (source) file! Make sure to always keep backup before compiling - I had to write the source code twice because of this.
