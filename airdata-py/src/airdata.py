# Atmospheric data - Legend:
# SI units: 
#    alt = Altitude ( m )
#    cp  = Atm. Pressure ( N/m^2 )
#    cr  = Atm. Density ( Kg/m^3 )
#    ct  = Atm. Temperature ( K )
# Imperial units: 
#    alt = Altitude ( ft )
#    cp  = Atm. Pressure ( atm )
#    cr  = Atm. Density ( gr/cm^3 )
#    ct  = Atm. Temperature ( C )

import math

def airdata_from_alt( alt, grads=1 ):
#input: alt = altitude in (m) or (ft),
#       grads=1 (SI), grads=0 (Imperial)
#return: [cp,cr,ct] 

	R0=1.225000            #--> Kg/m^3
	P0=1.013E+5            #--> N/m^2
	T0=288.000             #--> K

	L=0.0065               #--> K/m
	R=287.000              #--> m^2/(sec.K)
	G=9.810                #--> m/sec^2

	if ((alt<0) or (grads not in [0,1])):
		return nil
		
	# setup conversion constants and input parameters
	if (grads==1):
		mode_a=mode_p=mode_r=1.0
		mode_t=0.0
	else:
		mode_a=0.3048
		mode_p=P0
		mode_r=0.001
		mode_t=-273.0
				
	# initialize base parameters, convert altitude to (m)
	alt=alt*mode_a	
	temp = [ 0.0, G/(R*L), (G-R*L)/(R*L), 1-L*11000.000/T0, 0, 0 ];
	temp[4] = P0*(temp[3]**temp[1])
	temp[5] = R0*(temp[3]**temp[2])

	# core calculations based on altitude (m)
	if (alt<=11000.000):
		temp[0] = 1-L*alt/T0
		cp = P0*(temp[0]**temp[1])/mode_p
		cr = R0*(temp[0]**temp[2])*mode_r
		ct = (T0-L*alt)+mode_t
	else:
		temp[0] = (11000.000-alt)/(R*216.500)
		cp = temp[4]*math.exp(temp[0])/mode_p
		cr = temp[5]*math.exp(temp[0])*mode_r
		ct = 216.500+mode_t

    # results in the proper units (SI or Imperial)
	return [cp,cr,ct]


# -----  main program (run as script)  -----
if __name__ == "__main__" :
	for k in range(10,-1,-1):
		[cp,cr,ct]=airdata_from_alt(k*3000,1)
		print("alt=%g --> pr=%g , r=%g , t=%g" % (k*3000,cp,cr,ct))
