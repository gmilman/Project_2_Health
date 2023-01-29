-- Create a database for Healthcare project
CREATE DATABASE Healthcare;
USE Healthcare;  -- choose your database here

SELECT * FROM healthcare.composite_2021;

-- Change the name of the column sum(exp_K$)
ALTER TABLE Composite_2021
RENAME COLUMN `sum(exp_K$)` TO exp_K$;

-- Creata a temporary table to calculate the indicators from the compsite_2021 table



CREATE TEMPORARY TABLE  NormalizedTable
SELECT F.area, F.year, facilities, perc_deaths, Cases, access_meds, Expend_PP FROM
	(SELECT area, year,
		(nb_fac_per_100k-(SELECT MIN(nb_fac_per_100k) FROM composite_2021)) / 
			(SELECT (MAX(nb_fac_per_100k)-MIN(nb_fac_per_100k)) FROM composite_2021) 
			AS Facilities FROM composite_2021) F
left join 
	(select area, 
			(percent_deaths-(SELECT MIN(percent_deaths) FROM composite_2021)) / 
			(SELECT (MAX(percent_deaths)-MIN(percent_deaths)) FROM composite_2021) 
			AS perc_Deaths FROM composite_2021) D 
	on F.area=D.area
left join 
	(select area, 
			(nb_cases-(SELECT MIN(nb_cases) FROM composite_2021)) / 
			(SELECT (MAX(nb_cases)-MIN(nb_cases)) FROM composite_2021) 
			AS Cases FROM composite_2021) N
	on F.area = N.area
left join
	(select area, 
			(exp_pperson-(SELECT MIN(exp_pperson) FROM composite_2021)) / 
            (SELECT (MAX(exp_pperson)-MIN(exp_pperson)) FROM composite_2021) 
            AS Expend_pp FROM composite_2021) E
	on F.area = E.area
    left join
	(select area, 
			(percent_access_meds-(SELECT MIN(percent_access_meds) FROM composite_2021)) / 
            (SELECT (MAX(percent_access_meds)-MIN(percent_access_meds)) FROM composite_2021) 
            AS access_meds FROM composite_2021) M
	on M.area = E.area;

-- Use the temporary table to calculate the indicators of each country

create table HIV_indicators
select area, year, Facilities, perc_Deaths, Cases, access_meds, Expend_pp, 
	(Facilities*0.5 + perc_Deaths*(-1) + Cases*(-1) + access_meds*1 + Expend_pp*1) AS indicators 
	FROM NormalizedTable order by indicators desc;
    
    select * from HIV_indicators;



