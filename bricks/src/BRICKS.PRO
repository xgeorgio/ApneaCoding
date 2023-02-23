
/***********************************************

   BRICKS is a program in Turbo Prolog 2.0
   used to demonstrate solution searching
   through logic programming. It solves the
   classic problem of building a stable tower of
   given height using pre-defined block sizes.
   
   Towers are declared as lists of blocks.
   The tower(T,H) can be used either to test if
   a tower has actually the given (total) height,
   or to calculate its height H with:
       tower([brick1,brick2,brick3]),H)
       
   A tower is stable only if every block has
   blocks of equal or lower height above it.
   The stability of a tower can be tested with
   the stable(T) clause:
       stable([brick2,brick1])
   To build a tower of a given height from scratch:
       buildtower(T,4)
   Stable towers can also be built from scratch:
       buildstabletower(T,4)
       
   When using the executable compiled source, the
   goal must be set in the GOAL section, e.g. with
   a prompt for the user to enter the desired tower
   height. However, this source does not include a
   proper clause for complete solution display, 
   which must print the nested lists returned as
   the output (IDE does this automatically).
   
 *****************************************************/
 
 
DOMAINS
 
brick1, brick2, brick3 = symbol
list = symbol*
 
 
PREDICATES
 
block( symbol, integer )
blocklen( symbol, integer )
maxblockheight( integer )
 
link( list, list, list )
 
tower( list, integer )
towerlen( list, integer, integer )
 
stablepart( list, integer )
stable( list )
 
extendtower( list, integer, list, integer )
buildtower( list, integer )
extendstabletower( list, integer, integer, list, integer )
buildstabletower( list, integer )
 
 
CLAUSES
 
/*** Declaration of blocks and their heights ***
 ***    Calling convention:  block(io,io)    ***/
  
block(brick1,1).
block(brick2,2).
block(brick3,3).
  
  
/*** The number here is the max-of-block-heights. ***
 *** It is needed internally by stable(T) when it ***
 *** begins, to ensure correct output for the top ***
 *** brick of the tower.                          ***
 ***   Calling convention:  maxblockheight(o)     ***/
 
maxblockheight(1000).


/*** General-purpose list linking clause ***
 *** (L1=first, L2=second, L3=result)    ***
 ***    Calling convention:  link(i,i,o) ***/
 
link([],L,L).
link([B|L1],L2,[B|L3]):-
    link(L1,L2,L3).
    
    
/*** Find out the height of a given block  ***
 *** It is similar to block(B,H), but with ***
 *** a more specific calling convention.   ***
 ***    Calling convention:  blocklen(i,o) ***/
 
blocklen(B,H):-block(B,H).


/*** Check the total height of a tower against a   ***
 *** given one. If both parameters are specified   ***
 *** the two heights (actual/given) are compared   ***
 *** for equality. If only T is given, the actual  ***
 *** total height is returned. The internal clause ***
 *** towerlen(T,Hin,Hout) is used to implement a   ***
 *** counter through recursive calls of tower(T,H) ***
 ***    Calling convention:  tower(i,io)           ***
 ***                       ( towerlen(i,i,o) )     ***/
 
towerlen([],H,H).
towerlen([B|T],Hin,Hout):-
    blocklen(B,BH),NH=Hin+BH,!,towerlen(T,NH,Hout).

tower(T,H):-towerlen(T,0,H).


/*** Check a tower for stability. The only parameter     ***
 *** given is the tower to be checked. The internal      ***
 *** clause stablepart(T,PH) is used to check the height ***
 *** of the (current) top brick against the height of    ***
 *** the one just above it, through recursive calls.     ***
 ***    Calling convention:  stable(i)                   ***
 ***                       ( stablepart(i,i) )           ***/
 
stablepart([],_).
stablepart([B|T],PH):-
    blocklen(B,H),H<=PH,stablepart(T,H).

stable(T):-
    maxblockheight(MH),stablepart(T,MH).


/*** Extend a tower of given height to a new (higher)  ***
 *** one. The first two parameters define the old one  ***
 *** the fourth is the new height and the new tower is ***
 *** returned through the 3rd parameter.               ***
 ***    Calling convention:  extendtower(i,i,o,i)      ***/
 
extendtower(T,H,T,H).
extendtower(T,H,NT,NH):-
    NH>H,block(B,H),link([B],T,TT),tower(TT,HH),HH<=NH,
    extendtower(TT,HH,NT,NH).


/*** Build a tower of a given height, using the ***
 *** existing blocks. It is implemented through ***
 *** extendtower(T,H,NT,NH).                    ***
 ***    Calling convention:  buildtower(o,i)    ***/
 
buildtower(T,H):-extendtower([],0,T,H).


/*** Extend a tower of given height to a new (higher)     ***
 *** stable one. The first three parameters define the    ***
 *** old one (the 3rd parameter is the height of the      ***
 *** top brick), the 5th is the new height and the        ***
 *** new tower is returned through the 4th parameter.     ***
 ***    Calling convention:  extendstabletower(i,i,i,o,i) ***/
 
extendstabletower(T,H,_,T,H).
extendstabletower(T,H,W,NT,NH):-
    NH>H,block(B,BH),BH>=W,link([B],T,TT),tower(TT,HH),HH<=NH,
    extendstabletower(TT,HH,BH,NT,NH).
    
    
/*** Build a stable tower of a given height, using the ***
 *** existing bricks. It is implemented through the    ***
 *** internal clause extendstabletower(T,H,W,NT,NH).   ***
 ***    Calling convention:  buildstabletower(o,i)     ***/
 
buildstabletower(T,H):-extendstabletower([],0,0,T,H).

