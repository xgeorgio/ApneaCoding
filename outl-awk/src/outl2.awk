awk 'BEGIN{L=2;n1=0;m1x=-30;m1y=-30;s1x=15;s1y=12;n2=0;m2x=70;m2y=70;s2x=10;s2y=7;dx=0;dy=0}; $3==1{dx=($1-m1x)/s1x;dx=(dx<0)?-dx:dx;dy=($2-m1y)/s1y;dy=(dy<0)?-dy:dy;if((dx>L)||(dy>L)){n1++;print "1: " dx " " dy}}; $3==2{dx=($1-m2x)/s2x;dx=(dx<0)?-dx:dx;dy=($2-m2y)/s2y;dy=(dy<0)?-dy:dy;if((dx>L)||(dy>L)){n2++;print "2: " dx " " dy}}; END{print "Outliers: N1=" n1 ", N2=" n2}' XYdata.txt

1: 1.85885 2.14055
1: 1.12024 2.3831
1: 0.873892 2.10238
1: 2.29492 0.909004
2: 0.486175 2.02169
2: 2.46721 1.26579
2: 2.18952 0.355079
2: 2.7715 1.48925
2: 0.145815 2.06641
Outliers: N1=4, N2=5

xgeorgio@CircaQ8 ~
$