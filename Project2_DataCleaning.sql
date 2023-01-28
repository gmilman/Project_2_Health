create schema project_2;
use	project_2;

-- looking at data from UNAID webiste and which contains data expenditure
select distinct * from UNAID_Data
limit 10;

-- Extract data for the indicator field, 'HIV expenditure by key population', discard all other data
-- indicator divided by population subgroup e.g. 'sex workers', 'drug users'
		-- to calculate population level expenditure, add the totals for each subgroup, for each country 




-- country code and name - extracted to make a reference table for country codes
		-- this can then be used to get country name based on code

create table country_codes
select distinct Area, Area_ID from unaid_data;
select * from county_codes;

drop table HIV_expenditure;

create temporary table HIV_expenditure
select * from Unaid_data
where indicator = 'HIV expenditure by key population';

-- sum the expenditure values for each country, giving 1 row per country

Create table total_exp_cty_year_
select distinct area, area_ID, time_period as year, sum(Data_value) as exp_K$ from(
select distinct area, area_id, time_period, data_value from HIV_expenditure
where subgroup like '%Total%'
group by area, area_id,  time_period) exp_total;

select * from exp_cty_year;

-- cross expenditure table with number of cases

create table composite_by_subgroup;
select 
	area, area_id, 
    subgroup, 
    exp.year, 
    exp_K$, 
    num.value as nb_cases, mort.value as nb_deaths
    fac.value as nb_fac_per_100k
from exp_cty_year exp
join number_ppl_with_hiv num
on area_id = country_code and exp.year = num.year
join mortality_hiv mort
on num.country_code = mort.country_code and mort.year = num.year
join facilities_hiv fac
on fac.country_code = num.country_code
where num.value <> '' and mort.value <> '';



select * from exp_nb_cas_death_fac;

create table exp_nb_cas_death_fac
select area, area_id, year, sum(exp_K$), nb_cases, nb_deaths, nb_fac_per_100k
from composite_by_subgroup
group by area_id, area, year, nb_cases, nb_deaths, nb_fac_per_100k
order by area;

create table composite_2021
select distinct * from exp_nb_cas_death_fac
where year = 2021;



-- join table
where value <> '';

drop table number_ppl_with_hiv;
drop table composite_2021;