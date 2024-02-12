#include <stdio.h>
#include <math.h>

const double C_light_atm=299702.547;

double dist_from_dt( double dt, double T_air )
{
    double C_sound_air, Dist;

    C_sound_air=331.3*sqrt(1+T_air/273.15);
    Dist=C_light_atm/(C_light_atm+C_sound_air/1000);
    Dist=Dist*C_sound_air*dt;

    return(Dist);
}

double angleA( double dtA, double dtB, double T_air, double distAB )
{
    double distA, distB, angleA;

    distA=dist_from_dt(dtA,T_air);
    distB=dist_from_dt(dtB,T_air);
    angleA=distA*distA-distB*distB+distAB*distAB;
    angleA=angleA/(2*distA*distAB);
    angleA=acos(angleA);

    return(angleA);
}


int main( void )
{
    float tmA, tmB, tp, dA, dB, dAB;

    printf("Thunder triangulation from light/sound\n\n");

    printf("dT_A (sec)? ");  scanf("%f",&tmA);
    printf("dT_B (sec)? ");  scanf("%f",&tmB);
    printf("T_air (C) ? ");  scanf("%f",&tp);
    printf("distAB (m)? ");  scanf("%f",&dAB);

    dA=dist_from_dt(tmA,tp);
    dB=dist_from_dt(tmB,tp);

    printf("\ndistA=%g (m), distB=%g (m)\n",dA,dB);
    printf("angle(A/B) = %g (deg)\n",angleA(tmA,tmB,tp,dAB)*180/M_PI);
    printf("angle(A\\B) = %g (deg)\n",angleA(tmB,tmA,tp,dAB)*180/M_PI);

    return(0);
}
