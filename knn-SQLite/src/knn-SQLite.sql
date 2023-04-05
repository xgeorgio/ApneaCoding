
-- K-nearest-neighbour classifier in SQL --


-- create table: data samples --
DROP TABLE IF EXISTS DATAXY;
CREATE TABLE DATAXY (
  id INTEGER NOT NULL,    -- used as reference key --
  x REAL NOT NULL,        -- X data element --
  y REAL NOT NULL,        -- Y data element --
  cid INTEGER NOT NULL    -- class ID (known) --
);

-- create table: testing samples --
DROP TABLE IF EXISTS TESTXY;
CREATE TABLE TESTXY (
  id INTEGER NOT NULL,    -- used as reference key --
  x REAL NOT NULL,        -- X data element --
  y REAL NOT NULL,        -- Y data element --
  cid INTEGER            -- class ID (unknown) --
);


-- insert data samples --
INSERT INTO DATAXY VALUES ( 1, 1.0, -1.0, -1);  -- classID:'-1' --
INSERT INTO DATAXY VALUES ( 2, 2.0, -1.0, -1);
INSERT INTO DATAXY VALUES ( 3, 2.5,  1.0, -1);
INSERT INTO DATAXY VALUES ( 4, 3.0,  0.0, -1);
INSERT INTO DATAXY VALUES ( 5, 3.5,  2.0, -1);

INSERT INTO DATAXY VALUES ( 6, 11.0, -1.0, 1);  -- classID:'+1' --
INSERT INTO DATAXY VALUES ( 7, 12.0, -1.0, 1);
INSERT INTO DATAXY VALUES ( 8, 12.5,  1.0, 1);
INSERT INTO DATAXY VALUES ( 9, 13.0,  0.0, 1);
INSERT INTO DATAXY VALUES (10, 13.5,  2.0, 1);

-- insert testing samples --
-- Note: keep only one row active for N=1 testing --
INSERT INTO TESTXY VALUES (91, 13.5,  0.3, NULL);
INSERT INTO TESTXY VALUES (92, 6.5, -2.0, NULL);
INSERT INTO TESTXY VALUES (93, 16.5, -9.0, NULL);


-- k-nn fetch, simple version (works for N=1 test sample) --
-- Note: As it is, for N>1 the results of all testing
-- samples are merged into one table without grouping
-- i.e., some FOR-EACH structure is necessary for this.

SELECT 
  --id1, id2, cidk  -- display the top K neighbours
  id2, SUM(cidk)/ABS(SUM(cidk))  -- display only the result
FROM TESTXY, (
  SELECT 
    DATAXY.id AS id1, TESTXY.id AS id2,
    -- calculate the Euclidean distance (squared) --
    ((DATAXY.x-TESTXY.x) * (DATAXY.x-TESTXY.x)
    + (DATAXY.y-TESTXY.y) * (DATAXY.y-TESTXY.y)) AS dist,
    -- keep the coresponding class ID --
    DATAXY.cid AS cidk
  FROM DATAXY, TESTXY
  ORDER BY id2, dist ASC -- sort against distances
  LIMIT 5 -- this is the K parameter
);


-- display table sizes as separator from results below
SELECT COUNT(*) FROM DATAXY;
SELECT COUNT(*) FROM TESTXY;


-- k-nn fetch, simple version (works for N>1 test samples) --
-- Note: A few hacks are necessary in order to get precisely
-- the 'summary' result with only sign (not sums) as classID.

-- activate for full results:
--SELECT id1, id2, cidk, rnum from (
-- activate if SQL supports SIGN(.):
--SELECT id2, SIGN(ssum) FROM (
-- take distinct rows, avoid duplicates due to (X,Y) pairing
SELECT DISTINCT 
  -- take the sum over each classID in the results
  id2, SUM(cidk) OVER(partition BY id2) AS ssum 
FROM (
  -- take distinct rows, avoid duplicates dur to (X,Y) pairing
  SELECT DISTINCT
    id1, id2, cidk, 
    -- add run numbering, resets for every classID (grouping)
    row_number() OVER(PARTITION BY id2) as rnum
  FROM TESTXY, (
    SELECT 
      DATAXY.id AS id1, TESTXY.id AS id2,
      -- calculate the Euclidean distance (squared) --
      ((DATAXY.x-TESTXY.x) * (DATAXY.x-TESTXY.x)
      + (DATAXY.y-TESTXY.y) * (DATAXY.y-TESTXY.y)) AS dist,
      -- keep the coresponding class ID --
      DATAXY.cid AS cidk
    FROM DATAXY, TESTXY
    ORDER BY id2, dist ASC 
  ) -- sort against distances
) 
WHERE rnum <= 5; -- this is the K parameter
--);  -- used when additional SELECT wrapper is enabled

