import numpy as np
import math
import matplotlib.pyplot as plt

# coefficients for the 4th-degree polynomial approximators
A=np.array([1.1048968, 0.62310300e-3, -0.21655676e-4, 0.10841363e-6, -0.14720401e-9]);
B=np.array([0.12321833, -0.24593090e-3, 0.13219840e-4, -0.67643523e-7, 0.90926050e-10]);
C=np.array([0.851527187, 1.64532521e-4, 1.30162335e-5, -7.27912620e-8, 9.86283730e-11]);

# set evaluation domain parameters
Ndays=365          # days of year (0...365)
Nhours=24          # hours of day (0...24)
theta=math.pi/2    # incident angle (0...pi/2)

# pre-allocate result vectors (solar flux)
Ib=np.zeros(Ndays*Nhours)    # direct
Id=np.zeros(Ndays*Nhours)    # ambient
I0=np.zeros(Ndays*Nhours)    # total (adjusted)

k=0
for day in range(Ndays):
  # re-calculate polynomial approximators for each day
  cA=0
  cB=0
  cC=0
  for j in range(5):
    cA += A[j]*(day**j)
    cB += B[j]*(day**j)
    cC += C[j]*(day**j)

  # re-calculate daily approximator for each hour
  # note: 'hr' must not include 0 or 24 because it will
  #   result in division-by-zero in the hourly formula.
  for hr in range(1,Nhours):
    Ib[k] = cA/math.exp(cB/math.sin(hr/Nhours*math.pi))*math.sin(theta)
    Id[k] = cC*Ib[k]
    k += 1

  # last-hour approximation via 1-step linear extrapolation
  # note: this is better than using range [0.5...23.5] as it
  #   includes an approximation for the singularity point
  #   while the +0.5 range adjustment just 'skips' it.
  Ib[k]=(Ib[k-1]-Ib[k-2])+Ib[k-1]
  Id[k]=cC*Ib[k]
  k += 1

# debug check: make sure the entire days*hours range has been covered
print('total points: %d (%dx%d=%d)' % (I0.size,Ndays,Nhours,Ndays*Nhours))

# normalize output for range [0...1]
I0=Ib+Id
mx=max(I0)
mn=min(I0)
# note: min value position corresponds to the day/hour of winter solistice
print('I0 : min=%g (idx=%d), max=%g (idx=%d)' % (mn,I0.argmin(),mx,I0.argmax()))
for k in range(I0.size):
  #(x-0)/(1-0)=(I0[k]-mn)/(mx-mn)
  I0[k]=(I0[k]-mn)/(mx-mn)

# visual display of the time series (total solar flux)
plt.plot(range(I0.size),I0)
plt.grid() 
plt.show() 
