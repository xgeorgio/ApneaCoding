Title:<br/>
<b>Any base-N calculations in Julia</b>

Description:<br/>
<p>This is a very short example directly in Julia's REPL, demonstrating how using simple built-in string functions can enable very fast arithmetic in any radix (base N), where N can be any integer 2<=N<=62. This is not just converting binary to string representation like in base64, it is actual math calculations way further than hexadecimal.</p> 
<p>Normally these conversions would take too much time especially in scripting languages like Python, but in Julia the JIT compilation makes it lightning fast - Benchmarks are presented in the second half of the video for both function-based and macro-based implementations, with clear difference in terms of speed.</p>
