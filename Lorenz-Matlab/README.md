Title:<br/>
<b>Chaos: Lorenz system in Matlab/Octave</b>

Description:<br/>
<p>Chaos is the transient regions of a system's state between deterministic and random behaviour. It is neither predictable or unpredictable. Edward Lorenz, a mathematician and meteorologist, was studying an arithmetic simulation of atmospheric conductivity system of equations, implemented in early-era '63 computers.</p> 
<p>According to the story, he set the system parameters to the specific values (r=28,b=8/3,s=10), hit "run" and went out for a coffee. When he returned he checked the printouts and discovered an exponentially divergence in the expected phase-shift trajectory. He assumed this was due to arithmetic rounding errors, so he ran the simulation again changing the parameters only slightly. He was suprised to see the same behaviour: chaos dynamics. An extremely small change in the initial conditions results in huge, unpredictable divergence after a while.</p>
<p>This code is a very short demo of how the original three-parameter Lorenz system can be simulated with a 1st-order Euler method (dt timesteps), producing the famous 3-D "butterfly" plot. This implementation is coded in Octave, which is almost 100% compatible with Matlab.</p>
