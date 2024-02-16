/***
 * Geneva Score for assessing Pulmonary Embolism (PE) risk.
 * GS7: Using 7 risk factors, including blood gas analysis.
 * 
 * Details: https://en.wikipedia.org/wiki/Geneva_score
 * 
 * Warning: This is purely for educational purposes, not to 
 * be used for real clinical practice or pre-hospital care.
 * The author bares no responsibility for any such case.
***/

/* factor 1: age>=60, age>=80 */
age(X,R):- X<60,R=0.
age(X,R):- X>=60,X=<79,R=1.
age(X,R):- X>=80,R=2.

/* factor 2: previous DVT or PE */
dvt_pe(X,R):- X='Y',R=2.
dvt_pe(X,R):- X='N',R=0.

/* factor 3: recent surgery/fracture */
surg_frac(X,R):- X='Y',R=3.
surg_frac(X,R):- X='N',R=0.

/* factor 4: heart rate >100 bpm */
hr(X,R):- X=<100,R=0.
hr(X,R):- X>100,R=1.

/* factor 5: PaCO2 (mmHg) */
paco2(X,R):- X<35,R=2.
paco2(X,R):- X>=35,X=<39,R=1.
paco2(X,R):- X>39,R=0.

/* factor 6: PaO2 (mmHg) */
pao2(X,R):- X<49,R=4.
pao2(X,R):- X>=49,X=<59,R=3.
pao2(X,R):- X>=60,X=<71,R=2.
pao2(X,R):- X>=72,X=<82,R=1.
pao2(X,R):- X>82,R=0.

/* factor 7(a): band atelectasis */
atelec(X,R):- X='Y',R=1.
atelec(X,R):- X='N',R=0.

/* factor 7(b): elevation of hemidiaphragm */
hem_elev(X,R):- X='Y',R=1.
hem_elev(X,R):- X='N',R=0.

/* convert GS7 score to risk category (%prob) */
sc_prob(SC,PR):- SC>=0,SC<5,PR is 10.
sc_prob(SC,PR):- SC>=5,SC=<8,PR is 38.
sc_prob(SC,PR):- SC>8,PR is 81.


/* main script, executed as the 'goal' */
:- initialization(main).
main :- Age=73,       /* input: factor 1 */
        DVT='Y',      /* input: factor 2 */
        Surg='Y',     /* input: factor 3 */
        HR=60,        /* input: factor 4 */
        PaCO2=37,     /* input: factor 5 */
        PaO2=55,      /* input: factor 6 */
        Atel='N',     /* input: factor 7(a) */
        HElev='N',    /* input: factor 7(b) */
        /* calculate partial scores and sum */
        age(Age,C1),dvt_pe(DVT,C2),surg_frac(Surg,C3),hr(HR,C4),
        paco2(PaCO2,C5),pao2(PaO2,C6),atelec(Atel,C7a),hem_elev(HElev,C7b),
        CC is C1+C2+C3+C4+C5+C6+C7a+C7b,
        /* print results */
        write('GS7 score: '),write(CC),write('/16'),nl,
        sc_prob(CC,PB),write('PE prob: '),write(PB),write('%'),nl.
        