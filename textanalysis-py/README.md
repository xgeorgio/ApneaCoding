Title:<br/>
<b>Letters counter in text files in Python</b>

Description:<br/>
<p>Simple question: How many times each letter appears in a text fragment or in a text file? This is often encountered as a trivial task in various situations, from carving multiple name labels to pre-processing for text compression (Huffman trees) - yet, there is no out-of-the-box solution in popular software like spreadsheets.</p>
<p>In this simple example, Python code is first written for inline text fragment, then extended to become a command-line tool that can process multiple input filenames as arguments. Although an overkill for this, the implementation uses dictionary for storing the letter counters, as this is probably the fastest and minimal code option.</p>
