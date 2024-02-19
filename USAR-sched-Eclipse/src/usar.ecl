/*
USAR team rotations and schedulling in Ops:

In an Urban SAR operational deployment of an organization there are
20 members with some of them having (one or more) three specialties.
There are specific demands for team size and specialties in 9 shifts
and there is a constraint of a slack of 2 'idle' rotations for rest.
This program solves the related constrained integer optimization
problem, producing any valid solutions (select "more").

The code is a modified version of the "crew assignment problem":
https://eclipseclp.org/examples/crew.ecl.txt
*/

% include all necessary libraries
:- lib(ic).
:- lib(ic_sets).
:- import subset/2 from ic_sets.

% define all shifts and specialties required
rotations(
  [rotation( 1,teamsize:6,experts:2,rookies:1,heavy:1,ropes:1,medic:1),
   rotation( 2,teamsize:6,experts:2,rookies:1,heavy:1,ropes:1,medic:1),
   rotation( 3,teamsize:7,experts:2,rookies:2,heavy:1,ropes:1,medic:1),
   rotation( 4,teamsize:6,experts:2,rookies:1,heavy:1,ropes:1,medic:1),
   rotation( 5,teamsize:6,experts:1,rookies:2,heavy:1,ropes:1,medic:1),
   rotation( 6,teamsize:7,experts:2,rookies:2,heavy:1,ropes:1,medic:1),
   rotation( 7,teamsize:6,experts:1,rookies:2,heavy:1,ropes:1,medic:1),
   rotation( 8,teamsize:5,experts:1,rookies:1,heavy:1,ropes:1,medic:1),
   rotation( 9,teamsize:5,experts:1,rookies:1,heavy:1,ropes:1,medic:1)]
).

% define all team members and any specialties each has
members(
     experts:[tom,david,jeremy,ron,joe,bill,fred,bob,mario,ed,juliet],
     rookies:[carol,janet,tracy,marilyn,carolyn,cathy,inez,jean,heather],
     heavy:[inez,bill,jean,juliet],
     medic:[tom,jeremy,mario,cathy,juliet],
     ropes:[bill,fred,joe,mario,marilyn,inez,heather]
).


% main solver starts here
usar :-
  % create all the intermediate lists
  members( experts:Experts,
           rookies:Rookies,
           heavy:Heavy,
           medic:Medic,
           ropes:Ropes ),

  % unify lists and get sizes
  append(Experts,Rookies,Members),
  length(Experts,Nexperts),
  length(Rookies,Nrookies),
  Nmembers is Nexperts + Nrookies,
  
  % map all symbolic sets to integer sets
  ( foreach(A,Members), count(I,1,Nmembers),
    foreach(I,SetMembers),
    fromto(HeavySet,HvIn,HvOut,[]),
    fromto(RopesSet,RpIn,RpOut,[]),
    fromto(MedicSet,MdIn,MdOut,[]),
    param(Heavy,Medic,Ropes)
  do
    (member(A,Heavy) -> HvIn = [I|HvOut] ; HvOut=HvIn ),
    (member(A,Ropes) -> RpIn = [I|RpOut] ; RpOut=RpIn ),
    (member(A,Medic) -> MdIn = [I|MdOut] ; MdOut=MdIn )
  ),

  StartRookies is Nexperts + 1,
  ( for(I,1,Nexperts), foreach(I,SetExperts) do true ),
  ( for(I,StartRookies,Nmembers), foreach(I,SetRookies) do true ),

  % get the shifts set for searching (constrained)
  rotations(Rotations),
  
  ( foreach(F,Rotations),
    foreach(Grp,Grps),
    param(SetMembers,SetExperts,SetRookies,HeavySet,MedicSet,RopesSet)
  do
    F=rotation(_,teamsize:C,experts:Nexp,rookies:Nrok,heavy:Nhv,ropes:Nrp,medic:Nmd),
    Grp subset SetMembers,
	% apply all constraints in any candidate solution
    #(Grp,C),
    #(Grp /\ SetExperts,Cexp), Cexp #>= Nexp,
    #(Grp /\ SetRookies,Crok), Crok #>= Nrok,
    #(Grp /\ HeavySet,Chv), Chv #>= Nhv,
    #(Grp /\ RopesSet,Crp), Crp #>= Nrp,
    #(Grp /\ MedicSet,Cmd), Cmd #>= Nmd
  ),

  % apply shifts slack (gap) in team member rotations
  Grps = [Grp1,Grp2|_RestGrps],
  append(Grps,[Grp1,Grp2],AppGrps),
  shifts_slack(AppGrps, Nmembers),

  % at this point all valid solutions are available
  ( foreach(Gr,Grps) do insetdomain(Gr,_,_,_) ),

  Nm =.. [names|Members],
  
  % pretty printer of full solution (schedule)
  write('>> Teams and shifts:'), nl,  
  ( foreach(Gr,Grps), param(Nm), count(Sft,1,_)
  do	
    write(Sft), write(': '),	
    ( foreach(X,Gr), param(Nm)
    do
        arg(X,Nm,Name),
        write(Name), write(' ')
    ),nl
  ).

% helper predicate for shift slack in rotations
shifts_slack([X,Y,Z|Rest], Nmembers) :- !,
  all_disjoint([X,Y,Z]),
  #(X)+ #(Y)+ #(Z) #=< Nmembers,
  shifts_slack([Y,Z|Rest], Nmembers).
shifts_slack(_Rest, _Nmembers).


% Run solver:
%    ?- usar.
