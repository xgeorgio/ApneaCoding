
-- IR seeker tracking algorithm for spin-scan sensor --
--
-- This small demo illustrates how the IR sensor signal of a guidance system 
-- based on spin-scan "rising sun" pattern can be processed in order to 
-- detect targets and extract bearing and strength (distance) information.
-- 
-- The "rising sun" spin-scan generates basic phase and amplitude modulation
-- that can be analyzed providing multi-target detection within the available
-- Field-Of-View (FOV). However, it is notoriously sensitive to strong IR 
-- sources within FOV, like the sun, flares (counter-measures), etc.
-- 
-- DISCLAIMER: The current code is designed and implemented based entirely
-- on publicly available material. No classified, commercial or patented
-- sources were used whatsoever, any such similarily is purely coincidental 
-- and does not infringe the author in any way. For details see:
--   * "Infrared homing" (see: "Spin-scan" / "Hamburg system"):
--         https://en.wikipedia.org/wiki/Infrared_homing
--   * Alvaro Pastor (2020): "Infrared guidance systems. 
--     A review of two man-portable defense applications"
--         https://osf.io/c6gxf/

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Float_Text_IO; use Ada.Float_Text_IO;
with Ada.Numerics; use Ada.Numerics;

-- main procedure starts here --
procedure IRseeker is

  -- define data vector type for easier declarations --
  type DataVec_Type is array (Integer range <>) of Integer;

  -- define global constants --
  N   : constant := 36;         -- sensory data series length (FOV "slots")
  FOV : constant := 60.0;       -- field-of-view (FOV) in degrees
  detLimit  : constant := 20;   -- detection threshold (difference) (test: 20, 50)
  detLength : constant := 2;    -- minimum run-length for detection (test: 2, 5)

  -- define sample sensory data series (IR seeker) --
  -- only the "open" half-circle of the "rising sun" is included here,
  -- assuming spin-scan from 0 to pi (counter-clockwise)
  -- Note: 1st target is at FOV/3 (weak), 2nd is at FOV/2 (stromg)
  seekerData : DataVec_Type (1 .. N) :=
    (   2,   1,   2,   2,   3,   2,   0,   1,   1,   2,   2,   1,   
      -- first target starts here (weak), about -9 deg (FOV)
       33,   2,  34,   3,  35,   2, 
      -- second target starts here (strong), about +1 deg (FOV)
	  100,   2, 105,   3, 103,   5, 
      101,   2, 101,   1, 102,   3, 105,   2, 111,   1, 100,   3  );

  numTargets : Integer := 0;    -- number of targers found
  

  -- convert FOV slots to bearing angle (in degrees) --
  function deltaToTheta ( 
      dtime : Integer )    -- time step of detection
    return Integer            -- return bearing angle
    is 
      theta : Integer;
    begin
      -- conversion FOV-to-bearing: [1..N] -> [-FOV/2..+FOV/2]
      theta := Integer(FOV * (dtime-1)/(N-1) - (FOV/2));
      return theta;
    end;
  
  -- display target detection information --
  procedure displayDetection (
      id  : Integer;
      pos : Integer;
      pwr : Integer ) 
    is
    begin
      Put_Line("Target detected:");
      Put_Line("     ID:");
      Put(id);
      Put_Line(" ");
      --Put_Line("FOV slot:");
      --Put(pos);
      --Put_Line(" ");
      Put_Line("     Bearing (deg):");
      Put(deltaToTheta(pos));
      Put_Line(" ");
      Put_Line("     Signal power (raw):");
      Put(pwr);
      Put_Line(" ");
    end;
    
  -- analyze IR seeker data, detect targets within the FOV --
  function analyzeData 
  return Integer 
  is
      p    : Integer;             -- FOV slot (counter)
      id   : Integer := 0;        -- target ID (counter)
      det  : Integer := 0;        -- detection slots in sequence
      pwr  : Integer := 0;        -- rel. power of detection 
      pwr0 : Integer := detLimit; -- rel. power baseline (adaptive)
      disp : Boolean := False;    -- target reporting (flag)
    begin
      -- process the FOV slots
      for p in 1..(seekerData'Length)-1 loop
        -- rel. power is current detection 'step'
        pwr := abs(seekerData(p+1)-seekerData(p));
        if pwr>=detLimit then
          -- detection valid, continue analysis
          if pwr > pwr0+detLimit then
            -- strong new 'step' from baseline (new target)
            pwr0 := pwr;     -- update the baseline
            det := 0;        -- reset the run-length
            disp := False;   -- enable target reporting
          end if;
          
          det := det + 1;
          -- check run-length, display target if new 
          if (det >= detLength) and (not disp) then
            id := id + 1;
            -- adjust FOV slot reporting against loop offsets
            displayDetection( id, p-det+2, pwr );
            pwr0 := pwr;     -- update the baseline
            disp := True;    -- disable target reporing
          end if;
        else
          -- now in 'no-target' slot, reset everything
          det  := 0;
          disp := False;
        end if;
      end loop;
      
      return id;    -- return the number of targets found
    end;
      

-- main procedure code --
begin
  Put_Line("IR spin-scan seeker tracking algorithm");
  Put_Line(" ");
  Put_Line("Scanning...");
  Put_Line(" ");
  
  numTargets := analyzeData;
  if (numTargets = 0) then
    Put_Line("No targets detected.");
  end if;
end IRseeker;
