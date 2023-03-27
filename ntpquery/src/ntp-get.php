<?php
	function ping($host, $port=123, $timeout=200) 
	{ 
	  echo $host;
	  $tB = microtime(true); 
	  $fP = fSockOpen($host, $port, $errno, $errstr, $timeout); 
	  if (!$fP) { return "down"; } 
	  $tA = microtime(true); 
	  $ptime = round((($tA - $tB) * 1000), 0)." ms"; 	  
	  echo "\t: $ptime (ms)\n";
	}

	function ntp_query( $host, $port=123 )
	{
		// display current server for query
		echo $host;
		// send NTP request
		$sock=@fsockopen("udp://$host", $port, $err_no, $err_str, 1);
		if (!$sock)
		{ echo "\t(unavailable)\n";	return; }
	
		$time_start = microtime(true);

		fwrite( $sock, chr(0x1b).str_repeat("\0", 47));
		// get NTP response and convert
		$resp = fread($sock, 48);

		$delay = round(((microtime(true) - $time_start) * 1000), 0);

		$utime = unpack( 'N', $resp, 40)[1]-2208988800;
	    $utc=date("Y-m-d H:i:s", $utime);
	    echo "\t: $utc (roundtrip: $delay ms)\n";
	}


// ..... main routine used for unit testing .....

	ntp_query('time.windows.com');
	ntp_query('time.cloudflare.com');
	ntp_query('time.facebook.com');
	ntp_query('time.windows.com');
	ntp_query('time.apple.com');
	ntp_query('time.euro.apple.com');
	//ntp_query('ntp1.vniiftri.ru');
	//ntp_query('vniiftri.khv.ru');
	//ntp_query('ntp21.vniiftri.ru');
	//ntp_query('stratum1.net');
	//ntp_query('ntp.time.in.ua');
	//ntp_query('ts1.aco.net');
	//ntp_query('tick.usask.ca');
	ntp_query('ntp.nict.jp');
	//ntp_query('pool.ntp.org');
	
	//ping('www.windows.com',80,10);
	//ping('www.cloudflare.com',80,10);
	//ping('www.google.com',80,10);
	//ping('time.facebook.com');
	//ping('time.windows.com');
	//ping('time.apple.com');
	//ping('time.euro.apple.com');
	//ping('ntp.nict.jp');
	
?>
