Title:<br/>
<b>Counter-artillery radar algorithms in Fortran</b>

Description:<br/>
<p>This small demo illustrates how the counter-artillery radar system works in the software level. The radar beam illuminates the moving target, which is typically an artillery shell, mortar, rocket, etc, coming from the ground. A series of fast calculations are required in order to estimate the impact point and/or the source location. 

The radar measurements provide a series of reference points with target location (and speed, depending on radar) for the reconstruction of the complete flight path. The closer these reference points are to the "goal" (impact or source), the better the estimation of the location is. Additionally, if the trajectory is of high-arc low-speed, e.g. from mortar, the flight path is much closer to a perfect parabola and a 3rd-order polynomial fit solution is usually very accurate.

In this example, this challenging task is addressed the way these systems were designed back in the late-70s to mid-80s era. Specifically, only 8086-level CPUs and some 256K-512K RAM were available as hardware platform, for an analytical problem that in reality consists of a full system of non-linear differential equations that need to be solved almost in real time. In contrast, the software back then was designed in a much simpler way, implementing approximate solvers and low-complexity models for data fitting. 

In addition, here Fortran is used as the 'expected' programming language for this task, since the only other realistic option back then was pure x86 Assembly. Fortran is the first real general-purpose high-level programming language. It was officially introduced in 1957 by IBM's John Backus for programming mainframe machines to math applications. Despite being high-level, it had strict rules for text column alignment originating back to punchcard coding.

This program illustrates a full estimation cycle for source location finding, using any of two reference points if the trajectory (radar 'pings') with location and speed measurements, i.e., simulating a Doppler radar technology. The cycle consists of the following sub-programs:
1) Hermite polynomial fit, using two reference points with location and speed data for the moving target.
2) 1st-order derivative approximation at arbitrary points, using the polynomial fit from (1).
3) Root finding towards the start of the trajectory (ground level), using Newton-Raphson solver with (1) and (2).

For simplicity, the problem is set in a X-Y plane, i.e., only a ground axis (X) and an elevation axis (Y). If the no-air resistance is assummed or if the reference points are take very close together at the beginning of the trajectory (ignoring such non-linearities), then an almost-ballistic trajectory assumption is also valid and a 3rd-degree Hermite polynomial (constant acceleration) is very accurate as model for data fitting. Moreover, if elevation and total flight distance are relatively small (less than 7-10 km), then the domain space can be assummed planar with uniform gravity field and the full 3-D problem can be addressed by two simultaneous 2-D models (separated) like this one. In other words, if this is applied for small-scale acquisitions and tracking, it performs very close to the real systems designed around that era.

For more realistic software, closer to the specifications of modern-era systems, there are a few things that can be enhanced:
* Use many more reference points and employ some non-linear least-quares solver for better data fit.
* Real measurements include noise; this is typically addressed e.g. with Kalman filters.
* Higher altitudes and longer distances require spherical (e.g. Haversine) geometry calculations.
* Air resistance, of course, is a major factor; this introduces differential equations systems.
* If target is self-propelled and/or maneuvering, the trajectory is higher that 3rd-order polynomial.
* Several complete cycles are required for proper error estimation regarding the estimated outputs.
* In real-time systems, all these have to be completed in much less than 50-100 milliseconds.

The previous list is only indicative of how the current counter-artillery radar software works today, with at least two orders of magnitude more code in terms of software and 6-7 orders of magnitude more computational power and storage capacity in terms of hardware. On the other hand, a simple drop-in replacement in this simple design can be a polynomial data fit other than Hermite, e.g. with Lagrange or Newton interpolation, using no speed information but four reference points with location-only measurements.

Warning: In some older versions of Microsoft's Fortran 77, the batch process 'FORT.BAT' assumed that the input filename is given as argument *without* the '.FOR' extension. If it is given, then the output is unpredictable and usually results in a corrupted *original* (source) file! Make sure to always keep backup before compiling - I had to write the source code twice because of this.

DISCLAIMER: The current code is designed and implemented based entirely on publicly available material. No classified, commercial or patented sources were used whatsoever, any such similarily is purely coincidental and does not infringe the author in any way. For details see:
* "Counter-battery radar" -- https://en.wikipedia.org/wiki/Counter-battery_radar
* "AN/TPQ-37 Firefinder Weapon Locating System" -- https://www.radartutorial.eu/19.kartei/04.battle/pubs/cms01_050672.pdf
* Matthew R. Avery and Michael R. Shaw, "Tackling Complex Problems: Analysis of the AN/TPQ-53 Counterfire Radar" -- https://apps.dtic.mil/sti/pdfs/AD1124237.pdf
