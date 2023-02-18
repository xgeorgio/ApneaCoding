
{ Example code for estimating the value of 'pi'
  The method is a trivial Monte-Carlo sampling
  upon a quarter-circle using built-in 'random' }

program pi_estim;

var
    N, C       : Integer;     { N = sample size, C = counter }
    X, Y       : Real;        { X,Y = temp values for sampling }
    SUM1, SUM2 : Real;        { SUM1,SUM2 = sample counters }
    P1, P2     : Real;        { P1,P2 = pi value estimations }

begin

{ logo/input screen }
    writeln;
    writeln('PI value estimation via Monte-Carlo sampling');
    writeln('--------------------------------------------');
    writeln;
    write('Give sample size N: ');
    readln(N);

    writeln;
    write('Running sampling... Please wait...');

{ initialize sampling parameters }
    randomize;
    SUM1:=0;
    SUM2:=0;
    C:=N;

{ main loop }
    while C>0 do
      begin
           { step-1: take two independent randoms in [0,1] }
           X:=random;
           Y:=random;

           { step-2b: estimation via average area under curve (AUC) }
           SUM2:=SUM2+sqrt( 1-sqr(X) )+sqrt( 1-sqr(Y) );

           { step-2a: estimation via Euclidean distance }
           if sqrt( sqr(X) + sqr(Y) ) <= 1 then SUM1:=SUM1+1;

           { step-3: update loop counter }
           C:=C-1;
      end;

{ calculate the final value estimations }
    P1:=4*(SUM1/N);       { with Euclidean distance method, N samples }
    P2:=(2/N)*SUM2;       { with average AUC method, 2N samples }

{ display the results }
    writeln;
    writeln;
    writeln('Method 1 (Euclidean distance): ');
    writeln(' PI.est = ',P1:10:9,' (error=',(abs(P1-pi)/pi):10:9,')');
    writeln('Method 2 (average AUC): ');
    writeln(' PI.est = ',P2:10:9,' (error=',(abs(P2-pi)/pi):10:9,')');
    writeln;
    writeln('True value:  PI = ',pi:10:9);
    writeln;

end.
