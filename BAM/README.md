Title:<br/>
<b>BAM neural network in Arduino</b>

Description:<br/>
<p>This program is a demonstration of how neural networks can be implemented in very resource-limited hardware like microcontrollers. Specifically, Bidirectional Associative Memory (BAM) is implemented in Arduino Uno, a baseline reference platform that is capable of hosting advanced Machine Learning and AI algorithms, much more than simple rule-based and linear PID controller designs.

BAM is one of the few neural network architectures that: (a) employ purely deterministic training of their parameters-weights and (b) have very small computing requirements in terms of both memory and processing. Their main target is to implement arbitrary mappings between pairs of vectors, e.g. like custom multiplexers and FPGA-based circuits. Moreover, they can use soft-valued vectors (not only binary) and they work bi-directionally, i.e., for a given "output" the corresponding "input" can be retrieved too.

The core implementation is "vanilla" C that uses only integer-valued mappings for better processing speed. The Arduino design is implemented in the excellent Wokwi.com online platform, including a text-based LCD display for output. In this code, the BAM weight matrix is trained every time on boot, but in practice it can be pre-defined statically and loaded when switching on, saving additional memory from (unnecessary) training data for the vector mapping.

In the "src" and "bin" folders there is a console version of the code ("bamf.c"), which demonstrates how BAM can be implemented for use with soft-valued vectors.
