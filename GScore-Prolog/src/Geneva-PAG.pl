/***
 * Geneva Score for assessing Pulmonary Embolism (PE) risk.
 * PAG: Using 7 risk factors, pregnancy-adapted scoring.
 * 
 * Details: https://en.wikipedia.org/wiki/Geneva_score
 * 
 * Warning: This is purely for educational purposes, not to 
 * be used for real clinical practice or pre-hospital care.
 * The author bares no responsibility for any such case.
***/

/* factor 1: age>=40 */
age(X,R):- X>=40,R=1.
age(X,R):- X<40,R=0.

/* factor 2: previous DVT or PE */
dvt_pe(X,R):- X='Y',R=3.
dvt_pe(X,R):- X='N',R=0.

/* factor 3: recent surgery/fracture */
surg_frac(X,R):- X='Y',R=2.
surg_frac(X,R):- X='N',R=0.

/* factor 4: unilateral lower limb pain */
ull_pain(X,R):- X='Y',R=3.
ull_pain(X,R):- X='N',R=0.

/* factor 5: hemoptysis */
hmpty(X,R):- X='Y',R=2.
hmpty(X,R):- X='N',R=0.

/* factor 6: heart rate (bpm) */
hr(X,R):- X<110,R=0.
hr(X,R):- X>=110,R=5.

/* factor 7: deep pal.pain/edema of lower limb */
llu_edem(X,R):- X='Y',R=4.
llu_edem(X,R):- X='N',R=0.

/* convert PAG score to risk category (%prob) */
sc_prob(SC,PR):- SC>=0,SC=<1,PR is 10.
sc_prob(SC,PR):- SC>=2,SC=<6,PR is 50.
sc_prob(SC,PR):- SC>6,PR is 90.   /* arbitrary value >50% */


/* main script, executed as the 'goal' */
:- initialization(main).
main :- Age=42,       /* input: factor 1 */
        DVT='Y',      /* input: factor 2 */
        Surg='Y',     /* input: factor 3 */
        LPain='Y',    /* input: factor 4 */
        Hempt='N',    /* input: factor 5 */
        HR=112,       /* input: factor 6 */
        LLEd='N',     /* input: factor 7 */
        /* calculate partial scores and sum */
        age(Age,C1),dvt_pe(DVT,C2),surg_frac(Surg,C3),
        ull_pain(LPain,C5),hmpty(Hempt,C6),hr(HR,C7),llu_edem(LLEd,C8),
        CC is C1+C2+C3+C5+C6+C7+C8,
        /* print results */
        write('PAG score: '),write(CC),write('/20'),nl,
        sc_prob(CC,PB),write('PE prob: '),write(PB),write('%'),nl.
        