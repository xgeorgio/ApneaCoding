Title:<br/>
<b>SOSUS1L: Sonar array submarine finder - Linear geodesics</b>

Description:<br/>
<p>This small demo illustrates how the Sound Surveillance System (SOSUS) sonar array network of the Cold War era worked in the software level. The passive sonars were installed at the bottom of the ocean floor listening in the deep sound channel (SOFAR), which exhibits exceptional sound propagation for thousands of km.

Despite the severe degradation of the sound signal due to absorption, diffusion and multipath effects, having three or (preferrably) more reference points of detection provides enough data for source finding via multi-lateration. The first detection serves mostly as a time-reset, i.e., initiation of the process, in order to measure accurate time differences of arrival (TDOA) in subsequent listening stations installed at known locations.

In this "simplified" version, linear geodesics are assumed for Earth, leading to a standard 2x2 linear system to solve. This is valid only for very short distances (5-10 km) from the detectors, or medium distances (less than 0.5 Lat/Lon degrees) but with a target very close to the equi-distance "center" of the detection triangle.

Due to the very small linear system, a non-iterative solver is implemented via determinants. This is not recommended for large linear systems, however in this case it is very straight-forward, very short in code and non-iterative structure enables more aggressive optimizations by the compiler.

Three listeting stations in northern Atlantic Ocean are defined in this example, namely at Nova Scotia, Bermuda and Norfolk. Two test cases are used for demonstration, one for the equi-distance location and one a slightly pertubated location near it, in order to check the error in the solutions due to the linear geodesics assumption. The test data require precise estimation of the TDOA at the detection stations, which cannot be done accurately with realistic-geodesic mapping tools like Google Earth. Hence, the predefined TDOA data are close but not precisely at the values that a real SOSUS detection would report.

Warning: In some older versions of Microsoft's Fortran 77, the batch process 'FORT.BAT' assumed that the input filename is given as argument *without* the '.FOR' extension. If it is given, then the output is unpredictable and usually results in a corrupted *original* (source) file! Make sure to always keep backup before compiling - I had to write the source code twice because of this.

DISCLAIMER: The current code is designed and implemented based entirely on publicly available material. No classified, commercial or patented sources were used whatsoever, any such similarily is purely coincidental and does not infringe the author in any way. For details see:
* "SOSUS" -- https://en.wikipedia.org/wiki/SOSUS
* "SOFAR channel" -- https://en.wikipedia.org/wiki/SOFAR_channel
* Solomon, Louis P. (April 2011). "Memoir of the Long Range Acoustic Propagation Program". U.S. Navy Journal of Underwater Acoustics. 61 (2): 176–205.
