Title:<br/>
<b>1-pass Linear Interpolation in Awk</b>

Description:<br/>
<p>Awk is a unique case of command-line tools in Unix/Linux. Actually, it has been around since the very early distributions and it is probably the most widely-used general-purpose utility for text parsing. It integrates a complete C-like language that is capable of constructing complete processing pipelines for both structured (e.g. csv) and unstructured text.</p>
<p>In this one-line example, a text data file is processed and interpolated at the same time, producing an augmented output data file. Since data rows are processed as they come with only one-line memory storage (I/O buffer), this call can be applied to input files of any size.</p>
