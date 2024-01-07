import math
import matplotlib.pyplot as plt

print("Victor-Sierra search pattern planner\n")

drift_speed=float(input("Give drift speed (kts): "))
drift_phi0=float(input("Give drift bearing-to (deg): "))
drift_phi=90-drift_phi0
boat_speed=float(input("Give boat speed (kts): "))
boat_tleg=float(input("Give leg time (mins): "))

th=[2*math.pi/6*k+drift_phi/180*math.pi for k in range(6)]
vx=[boat_speed/60*boat_tleg*math.cos(thk) for thk in th]
vy=[boat_speed/60*boat_tleg*math.sin(thk) for thk in th]

drx=drift_speed/60*math.cos(drift_phi/180*math.pi)
dry=drift_speed/60*math.sin(drift_phi/180*math.pi)

fx=[drx*k for k in range(1,7)]
fy=[dry*k for k in range(1,7)]

wpx=[vx[k]+fx[k] for k in range(6)]
wpy=[vy[k]+fy[k] for k in range(6)]

runx=[0,wpx[0],wpx[1],drx*3,wpx[4],wpx[5],drx*6,wpx[2],wpx[3],drx*9]
runy=[0,wpy[0],wpy[1],dry*3,wpy[4],wpy[5],dry*6,wpy[2],wpy[3],dry*9]

print("\nSearch pattern setup:")
print("  Boat speed  = %g (kts) at %g (deg)" % (boat_speed,drift_phi0))
print("  Drift speed = %g (kts) at %g (deg)" % (drift_speed,drift_phi0))
print("Waypoints adjusted for drift: [x,y]")
for k in range(len(runx)):
    print("  [ %.3f , %.3f ]" % (runx[k],runy[k]))

plt.plot(runx,runy,"b*-")
plt.title("Victor-Sierra: movex / moveY (kts/60)", fontweight="bold")
plt.grid(True)
plt.show()
