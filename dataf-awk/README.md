Title:<br/>
<b>Data filtering in Awk</b>

Description:<br/>
<p>Awk is a unique case of command-line tools in Unix/Linux. Actually, it has been around since the very early distributions and it is probably the most widely-used general-purpose utility for text parsing. It integrates a complete C-like language that is capable of constructing complete processing pipelines for both structured (e.g. csv) and unstructured text.</p>
<p>In this example the use case is simple: In a log file (.csv) of scheduled flights throughout a specific month and year (April 2016), locate a specific pair of departure-destination airports (LEPA = Palma de Mallorca, Spain / LPPT = Lisbon, Portugal) and count the logged flights per direction. Awk is the perfect tool for such row-wise text processing in the command-line.</p>


