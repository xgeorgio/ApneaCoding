/***
 * Geneva Score for assessing Pulmonary Embolism (PE) risk.
 * GS8: Using 8 risk factors, without blood gas analysis.
 * 
 * Details: https://en.wikipedia.org/wiki/Geneva_score
 * 
 * Warning: This is purely for educational purposes, not to 
 * be used for real clinical practice or pre-hospital care.
 * The author bares no responsibility for any such case.
***/

/* factor 1: age>=65 */
age(X,R):- X>=65,R=1.
age(X,R):- X<65,R=0.

/* factor 2: previous DVT or PE */
dvt_pe(X,R):- X='Y',R=3.
dvt_pe(X,R):- X='N',R=0.

/* factor 3: recent surgery/fracture */
surg_frac(X,R):- X='Y',R=2.
surg_frac(X,R):- X='N',R=0.

/* factor 4: active malignancy */
malig(X,R):- X='Y',R=2.
malig(X,R):- X='N',R=0.

/* factor 5: unilateral lower limb pain */
ull_pain(X,R):- X='Y',R=3.
ull_pain(X,R):- X='N',R=0.

/* factor 6: hemoptysis */
hmpty(X,R):- X='Y',R=2.
hmpty(X,R):- X='N',R=0.

/* factor 7: heart rate (bpm) */
hr(X,R):- X<75,R=0.
hr(X,R):- X>=75,X=<94,R=3.
hr(X,R):- X>=95,R=5.

/* factor 8: deep pal.pain/edema of lower limb */
llu_edem(X,R):- X='Y',R=4.
llu_edem(X,R):- X='N',R=0.

/* convert GS8 score to risk category (%prob) */
sc_prob(SC,PR):- SC>=0,SC=<3,PR is 8.
sc_prob(SC,PR):- SC>=4,SC=<10,PR is 29.
sc_prob(SC,PR):- SC>=11,PR is 74.


/* main script, executed as the 'goal' */
:- initialization(main).
main :- Age=73,       /* input: factor 1 */
        DVT='Y',      /* input: factor 2 */
        Surg='Y',     /* input: factor 3 */
        Malg='N',     /* input: factor 4 */
        LPain='Y',    /* input: factor 5 */
        Hempt='N',    /* input: factor 6 */
        HR=60,        /* input: factor 7 */
        LLEd='N',     /* input: factor 8 */
        /* calculate partial scores and sum */
        age(Age,C1),dvt_pe(DVT,C2),surg_frac(Surg,C3),malig(Malg,C4),
        ull_pain(LPain,C5),hmpty(Hempt,C6),hr(HR,C7),llu_edem(LLEd,C8),
        CC is C1+C2+C3+C4+C5+C6+C7+C8,
        /* print results */
        write('GS8 score: '),write(CC),write('/22'),nl,
        sc_prob(CC,PB),write('PE prob: '),write(PB),write('%'),nl.
        