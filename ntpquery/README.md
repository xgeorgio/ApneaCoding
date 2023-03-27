Title:<br/>
<b>NTP server query in PHP</b>

Description:<br/>
<p>This is just a small snippet of PHP code illustrating basic socket programming for querying NTP server (network time) from multiple hosts, as well as the corresponding roundtrip time via ping. Normally, NTP is not used for sub-second precision, but roundtrip reporting is a verification that the delay is indeed much smaller 1 sec and the reported time is accurate down to seconds.