<?php
	$cent = mktime(12,0,0,1,1,2001);
	$now = time();
	$diff = $now - $cent;

	$days = floor($diff / 84600);
	$diff -= 84600*$days;
	$hours = floor($diff / 3600);
	$diff -= 3600*$hours;
	$mins = floor($diff / 60);
	$secs = $diff - 60*$mins;

	echo 'Time elapsed since this century began:', chr(10);
	echo $days,' days, ',$hours,' hours, ',$mins,' minutes, ',$secs,' seconds.';
?>

