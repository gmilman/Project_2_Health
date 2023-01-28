-- Create a database for Healthcare project
CREATE DATABASE Healthcare;
USE Healthcare;  -- choose your database here

SELECT * FROM healthcare.composite_2021;

-- Change the name of the column sum(exp_K$)
ALTER TABLE Composite_2021
RENAME COLUMN `sum(exp_K$)` TO exp_K$;

-- Creata a temporary table to calculate the indicators from the compsite_2021 table



CREATE TEMPORARY TABLE IF NOT EXISTS NormalizedTable
SELECT F.area, F.year, facilities, Deaths, Cases, Expenses FROM
	(SELECT area, year,
			(nb_fac_per_100k-(SELECT MIN(nb_fac_per_100k) FROM composite_2021)) / 
			(SELECT (MAX(nb_fac_per_100k)-MIN(nb_fac_per_100k)) FROM composite_2021) 
			AS Facilities FROM composite_2021) F
left join 
	(select area, 
			(nb_deaths-(SELECT MIN(nb_deaths) FROM composite_2021)) / 
			(SELECT (MAX(nb_deaths)-MIN(nb_deaths)) FROM composite_2021) 
			AS Deaths FROM composite_2021) D 
	on F.area=D.area
left join 
	(select area, 
			(nb_cases-(SELECT MIN(nb_cases) FROM composite_2021)) / 
			(SELECT (MAX(nb_cases)-MIN(nb_cases)) FROM composite_2021) 
			AS Cases FROM composite_2021) N
	on F.area = N.area
left join
	(select area, 
			(exp_K$-(SELECT MIN(exp_K$) FROM composite_2021)) / 
            (SELECT (MAX(exp_K$)-MIN(exp_K$)) FROM composite_2021) 
            AS Expenses FROM composite_2021) E
	on F.area = E.area;

-- Use the temporary table to calculate the indicators of each country
create table HIV_indicators
select area, year, Facilities, Deaths, Cases, Expenses, hiv_indicators
	(Facilities*2 + Deaths*(-1) + Cases*(-1) + Expenses*2) AS indicators 
	FROM NormalizedTable order by indicators desc;



