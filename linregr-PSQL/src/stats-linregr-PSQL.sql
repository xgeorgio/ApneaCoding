
-- Statistics and Linear Regression in X-Y data


-- create table: data samples --
--DROP TABLE IF EXISTS DATAXY;
CREATE TABLE DATAXY (
  id INTEGER NOT NULL,    -- used as reference key --
  x REAL NOT NULL,        -- X data element --
  y REAL NOT NULL,        -- Y data element --
  cid INTEGER NOT NULL    -- class ID (known) --
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

-- statistics -- 
SELECT 
  COUNT(DATAXY.y) AS Ycount,
  MIN(DATAXY.y) AS Ymin,
  MAX(DATAXY.y) AS Ymax,
  AVG(DATAXY.y) AS Yavg
FROM DATAXY;

-- variance -- 
SELECT 
    SUM( (DATAXY.y-(SELECT AVG(DATAXY.y) FROM DATAXY)) 
    * (DATAXY.y-(SELECT AVG(DATAXY.y) FROM DATAXY)) ) 
    / (COUNT(DATAXY.y)-1) 
    AS Yvar
FROM DATAXY;

-- linear regression -- 
SELECT 
    -- Axy: slope in y=Ax+B --
    ((Sy * Sxx) - (Sx * Sxy)) / ((N * (Sxx)) - (Sx * Sx)) AS Axy,
	-- Bxy: intercept in Ax+B
    ((N * Sxy) - (Sx * Sy)) / ((N * Sxx) - (Sx * Sx)) AS Bxy,
	-- Rxy: correlation coefficient of X-vs-Y --
    ((N * Sxy) - (Sx * Sy)) / SQRT( (((N * Sxx) - (Sx * Sx)) 
        * ((N * Syy - (Sy * Sy)))) ) AS Rxy,
	-- Rsq: linear determination coefficient r^2 --
    ((N * Sxy) - (Sx * Sy)) * ((N * Sxy) - (Sx * Sy)) 
        / ( ((N * Sxx) - (Sx * Sx)) * ((N * Syy - (Sy * Sy))) ) AS Rsq
FROM
    (SELECT 
      SUM(DATAXY.x) AS Sx, 
      SUM(DATAXY.y) AS Sy,
      SUM(DATAXY.x * DATAXY.x) AS Sxx,
      SUM(DATAXY.x * DATAXY.y) AS Sxy,
      SUM(DATAXY.y * DATAXY.y) AS Syy,
      COUNT(*) AS N
      FROM DATAXY) 
AS linregr;
