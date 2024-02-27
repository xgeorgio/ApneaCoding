Title:<br/>
<b>Epsilon estimation in Logo</b>

Description:<br/>
<p>In this simple demonstration, the floating-point accuracy, a.k.a. 'epsilon', is estimated in the retro version of IBM Logo. Not many people know that, due to its unique memory handling with data 'nodes' (linked list), exponents can be truly huge, way larger than any other 'native' implementation in modern programming languages. Although epsilon is comparable to any other (about 1.e-9), some arithmetic is valid even for infinitesimal numbers, e.g. 1.e-4000 is recognized correctly as greater-than zero.</p>
