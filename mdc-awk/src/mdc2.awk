awk 'BEGIN{n1=0;m1x=0;m1y=0;n2=0;m2x=0;m2y=0}; $3==1{n1++;m1x+=$1;m1y+=$2}; $3==2{n2++;m2x+=$1;m2y+=$2}; END{print "Classes: N1=" n1 ", N2=" n2 "\n1: (" m1x/n1 "," m1y/n1 ")\n2: (" m2x/n2 "," m2y/n2 ")"}' XYdata.txt

Classes: N1=60, N2=40
1: (-28.8887,-30.9343)
2: (70.4564,68.8968)
