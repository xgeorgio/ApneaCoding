-- Minimum Distance Classifier (MDC) --

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;

-- main procedure starts here --
procedure MDCmain is

  -- define data vector types for easier declarations --
  type FloatVec_Type is array (Integer range <>) of Float;
  type IntegerVec_Type is array (Integer range <>) of Integer;
  
  -- define global constants --
  -- N=samples, Cx=classID --
  N : constant := 10;
  C0 : constant := -1;
  C1 : constant := 1;

  -- filtered mean based on a classID --
  function Aver (
      data  : FloatVec_Type; 
      clsid : IntegerVec_Type;
      sel_clsid  : Integer ) 
      return Float
    is
    ssum  : Float := 0.0;
    i, sz : Integer := 0;
    begin
      for i in data'Range loop
        -- process only selected classID --
        if clsid(i) = sel_clsid then
          begin
            ssum := ssum + data(i);
            sz := sz + 1;
          end;
        end if;
      end loop;
      -- warning: no check for division by zero --
      return ssum / Float(sz);
    end Aver;
    
    -- find closest classID for a given point (X,Y) --
    function NearestC ( 
        xm1, ym1, xm2, ym2, xx, yy : Float )
        return Integer
      is
      d1, d2 : Float;
      begin
        -- calculate Euclidean distances (squared) --
        d1 := (xx-xm1)**2 + (yy-ym1)**2;
        d2 := (xx-xm2)**2 + (yy-ym2)**2;
        if d1 <= d2 then
          return C0;
        else
          return C1;
        end if;
      end;

    -- wrapper for formatted output of centers (X,Y) per classID --
    procedure PrintCenters ( xm1, ym1, xm2, ym2 : Float ) is
      begin
      	Put("Number of samples: ");
      	Put(N);
      	Put_Line("");
      	Put("Center (X,Y) for class:");
      	Put(C0);
      	Put_Line("");
      	Put( xm1 );
      	Put( ym1 );
      	Put_Line("");
      	Put("Center (X,Y) for class:");
      	Put(C1);
      	Put_Line("");
      	Put( xm2 );
      	Put( ym2 );
        Put_Line("");
      end;
    
    -- wrapper for printing unknown test samples (X,Y) --
    procedure PrintTests( 
        meanX1, meanY1, meanX2, meanY2 : Float;
        xtst, ytst : FloatVec_Type )
      is
      i, cid : Integer;
      xi, yi : Float;
      begin
        Put_Line("");
        Put_Line("Test points (X,Y):");
        for i in xtst'Range loop
          xi := xtst(i);
          yi := ytst(i);
          -- unknown classID is the closest class center (X,Y) --
          cid := NearestC( meanX1, meanY1, meanX2, meanY2, xi, yi );
      	  Put( xi );
      	  Put( yi );
      	  Put(" -> ");
          Put( cid );
          Put_Line("");
        end loop;
      end;

  -- define training data (X,Y) and their classID --
  vecX : FloatVec_Type (1 .. N) :=
    ( 0.0, 1.0, 2.0, 4.0, 2.0,  6.0, 8.0, 7.0, 9.0, 6.5 );
  vecY : FloatVec_Type (1 .. N) :=
    ( 4.0, 5.0, 1.0, 3.0, 3.0,  -1.0, 1.0, 2.0, -2.0, 5.0 );
  vecC : IntegerVec_Type (1 .. N) :=
    ( C0, C0, C0, C0, C0,  C1, C1, C1, C1, C1 );
    
  -- define testing data (X,Y), classID to be decided by MDC --
  testX : FloatVec_Type (1 .. 3) := ( 3.0, 5.0, 8.0 );
  testY : FloatVec_Type (1 .. 3) := ( 2.5, 5.0, 1.5 );

  -- centers (X,Y) for each of the two classID
  meanX1, meanY1, meanX2, meanY2 : Float := 0.0;

-- main procedure code --
begin
  -- MDC training: center (X,Y) for classID=C0 --
  meanX1 := Aver( vecX, vecC, C0 );
  meanY1 := Aver( vecY, vecC, C0 );
  -- MDC training: center (X,Y) for classID=C1 --
  meanX2 := Aver( vecX, vecC, C1 );
  meanY2 := Aver( vecY, vecC, C1 );
  -- print the trained MDC --  
  PrintCenters( meanX1, meanY1, meanX2, meanY2 );

  -- test the MDC with the unknown samples --
  PrintTests( meanX1, meanY1, meanX2, meanY2, testX, testY );

end MDCmain;
