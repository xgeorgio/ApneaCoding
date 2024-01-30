/*** Declaration of eat-conditions  ***
 *** This is the main constraint in ***
 *** the whole problem.             ***
 ***    Calling convention:  eats(io,io) ***/

eats(wolf,goat).
eats(goat,cabbage).


/*** Reverse sides/directions declaration  ***
 *** Original problem uses west/east sides ***
 ***    Calling convention:  fromto(i,o)   ***/

fromto(left,right).
fromto(right,left).


/*** General purpose clause to test  ***
 *** if an item is member of a list. ***
 ***    Calling convention:  memberof(i,i) ***/

memberof(X,[X|_]).
memberof(X,[_|L]):-memberof(X,L).


/*** Make a cross from one side to the other    ***
 *** The object to be moved is given and the    ***
 *** lists of objects in each side are updated. ***
 *** Additionally, the starting side is also    ***
 *** given to use the correct direction of move ***
 ***    Calling convention:  halfcross(i,i,io,i,o) ***/

halfcross(C,[IE,IW],[IIE,[C|IW]],Start,Cross):-
    memberof(C,IE), remove(C,IE,IIE),
    fromto(Start,End),
    Cross=[End,[farmer,C]].


/*** Make a double crossing, moving an object in ***
 *** each move. It is implemented with two calls ***
 *** of halfcross(C,LC,LD,St,CR) and the full    ***
 *** crossing list is created.                   ***
 ***    Calling convention:  fullcross(i,i,i,io,o) ***/

fullcross(C,D,[IE,IW],[IIE,IIW],CR):-
    halfcross(C,[IE,IW],[IEE,IWW],left,HC1),
    halfcross(D,[IWW,IEE],[IIW,IIE],right,HC2),
    CR=[HC1,HC2].


/*** Make a double crossing, moving an object only ***
 *** on return. It is implemented with one call of ***
 *** halfcross(C,LC,LD,St,CR) and the full         ***
 *** crossing list is created.                     ***
 ***    Calling convention:  null2half(i,i,io,o)   ***/

null2half(D,[IE,IW],[IIE,IIW],CR):-
    HC1=[right,[farmer]],
    halfcross(D,[IW,IE],[IIW,IIE],right,HC2),
    CR=[HC1,HC2].


/*** Make a double crossing, moving an object only ***
 *** on going. It is implemented with one call of  ***
 *** halfcross(C,D,LC,LD,St,CR) and the full       ***
 *** crossing list is created.                     ***
 ***    Calling convention:  half2null(i,i,io,o)   ***/ 

half2null(C,[IE,IW],[IIE,IIW],CR):-
    halfcross(C,[IE,IW],[IIE,IIW],left,HC1),
    HC2=[left,[farmer]],
    CR=[HC1,HC2].


/*** Make a double crossing, moving an object in      ***
 *** each move and check if each side is safe.        ***
 *** It is implemented with a fullcross(C,D,LC,LD,CR) ***
 *** and then a safeside(L) for each side. The full   ***
 *** crossing list is created.                        ***
 ***    Calling convention:  safecross(i,i,i,io,o)    ***/

safecross(C,D,[IE,IW],[IIE,IIW],CR):-
    fullcross(C,D,[IE,IW],[IIE,IIW],CR),
    safeside(IIE),safeside(IIW).


/*** Make a double crossing, moving an object only on ***
 *** going and check if if side is safe.              ***
 *** It is implemented with a half2null(C,LC,LD,CR)   ***
 *** and then a safeside(L) for each side. The full   ***
 *** crossing list is created.                        ***
 ***    Calling convention:  safecrossr(i,i,io,o)    ***/

safecrossr(C,[IE,IW],[IIE,IIW],CR):-
    half2null(C,[IE,IW],[IIE,IIW],CR),
    safeside(IIE),safeside(IIW).


/*** Make a double crossing, moving an object only on ***
 *** return and check if if side is safe.             ***
 *** It is implemented with a null2half(D,LC,LD,CR)   ***
 *** and then a safeside(L) for each side. The full   ***
 *** crossing list is created.                        ***
 ***    Calling convention:  safecrossl(i,i,io,o)    ***/

safecrossl(D,[IE,IW],[IIE,IIW],CR):-
    null2half(D,[IE,IW],[IIE,IIW],CR),
    safeside(IIE),safeside(IIW).


/*** General purpose clause for removing ***
 *** an item from a list.                ***
 ***    Calling convention:  remove(i,i,o) ***/

remove(_,[],[]).
remove(X,[X|L1],L1):-!.
remove(Y,[X|L1],[X|L2]):-
    remove(Y,L1,L2).


/*** Check for safety conditions in a side    ***
 *** A side is safe if the farmer is present  ***
 *** or the side has one or none objects, or  ***
 *** the side has more than one objects with  ***
 *** no farmer, and none of them eats another ***
 ***    Calling convention:  safeside(L)      ***/

safeside([]):-!.
safeside([_]):-!.
safeside(S):- memberof(farmer,S),!.
safeside([I1,I2|_]):- eats(I1,I2),!,fail.
safeside([I1,I2|_]):- eats(I2,I1),!,fail.
safeside([_,I2|S]):- safeside([I2|S]).


/*** Describe the full crossing sequence to transfer ***
 *** objects from a starting condition to a final    ***
 *** condition. The set of solutions are given as a  ***
 *** list of double-crossings in sequence.           ***
 ***    Calling convention:  crossings(i,i,o)        ***/

crossings([FL,FR],[FL,FR],CR,CR).
crossings([IL,IR],[FL,FR],CR,NCR):-
    memberof(C,IL),memberof(D,IR),
    safecross(C,D,[IL,IR],[IIL,IIR],CCR),
    NCR=[CCR|CR],!,crossings([IIL,IIR],[FL,FR],NCR,_).
crossings([IL,IR],[FL,FR],CR,NCR):-
    memberof(C,IL),safecrossr(C,[IL,IR],[IIL,IIR],CCR),
    NCR=[CCR|CR],!,crossings([IIL,IIR],[FL,FR],NCR,_).
crossings([IL,IR],[FL,FR],CR,NCR):-
    memberof(D,IR),safecrossl(D,[IL,IR],[IIL,IIR],CCR),
    NCR=[CCR|CR],!,crossings([IIL,IIR],[FL,FR],NCR,_).


/*** Main predicate, the "Goal" to search ***
 *** for when this script is executed     ***/
 
main:-crossings([[farmer,goat,cabbage,wolf],[]],[[farmer,cabbage,wolf],[goat]],[],CR),
    print('Solution:'),nl,print(CR),nl.

:- initialization(main).
