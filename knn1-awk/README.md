Title:<br/>
<b>k-nearest-neighbour classifier in Awk</b>

Description:<br/>
<p>Awk is a unique case of command-line tools in Unix/Linux. Actually, it has been around since the very early distributions and it is probably the most widely-used general-purpose utility for text parsing. It integrates a complete C-like language that is capable of constructing complete processing pipelines for both structured (e.g. csv) and unstructured text.</p>
<p>In this one-line example, a text X-Y data file is processed as a training dataset, using an additional input pair as query point for assigning the minimum-distance single-neighbour (k=1) class. Since data rows are processed as they come with only one-line memory storage (I/O buffer), this call can be applied to input files of any size.
</p>


