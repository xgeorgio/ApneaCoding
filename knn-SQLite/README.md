Title:<br/>
<b>K-nn classifier in SQLite</b>

Description:<br/>
<p>This is a set of SQL queries demonstrating how in-server data processing can enable some basic data analytics. The K-nearest-neighbor (K-nn) classifier is implemented in two ways, one with a shorter query for a single test sample and one with a more extensive query classifying multiple test samples. It may seem mute when this can be easily done with Python or other code in fewer lines. But pushing the data processing part within the RDBMS server via properly crafted SQL can enable ultra-low-power IoT devices with absolutely minimal memory and processing resources (for example a micro-controller) to do stuff that are typically unfeasible otherwise.
