# PROJECT HEALTHCARE
project to develop composite indicator using SQL and API 

## Sources of data

Expenditure per country _ vaule = K$
* https://kpatlas.unaids.org/dashboard

Estimated number of people (all ages) living with HIV
* WHO
* https://www.who.int/data/gho/data/indicators/indicator-details/GHO/estimated-number-of-people--living-with-hiv

Testing and counselling facilities, estimated number per 100 000 adult population
* WHO
*https://www.who.int/data/gho/data/indicators/indicator-details/GHO/testing-and-counselling-facilities-estimated-number-per-100-000-adult-population

Reported number of people receiving antiretroviral therapy
* WHO
*https://www.who.int/data/gho/data/indicators/indicator-details/GHO/reported-number-of-people-receiving-antiretroviral-therapy

## Challenges
- exporting data collected via API, from json to something useful
- finding complete useful data sets

Process-
- started with subject - and identidied API wrapper for WHO data sets
- explored WHO website for data and settled on the area of HIV as the data sets were extensive and very complete.
- API used to extract for the WHO sources of data
- Exploration of other sources of date:
    - initially thought about exploring investment in healthcare, but quickly became clear that data was limited.
    - based on published article found sources for expenditure on HIV by country
    - a csv file was downloaded containing this data
- 4 data sets identified
    - number of cases per country (API)
    - mortality per country (API)
    - testing and counseling facilities per country (data already normalised (nb per 100,000 inhabitants) (API)
    - expenditure per country (downloaded as csv file)
- data imported and cleaned
- data normalised
- indicator calculated

## Methodlogy for cleaning

- Data imported from csv files using importation wizard.
- field/data alignment checked
- 4 tables created:
        1) number of cases / country/ year
        2) number of deaths / country / year
        3) number of facilities / 100,000 inhabitants / country
        4) total expenditure on HIV / country
- data crossed to find countries that have data in all 4 categories and for the same year
- looked at more recent data rather than older data
- decided to go for most recent, 2021 for which there was data on 15 countries for all 4 categories.
  - 2019 had more data (27 countries) but we decided on more recent data.
-expenditure included population subgroups, thus total expenditure was summed for all subgroups/country

## Methodology for normalization
- each value in each category normalised using the formula (X-Xmin)/(Xmax-Xmin)
- a weight was assigned to each category
      - -1 to negative factors
      - 1 to positive factors
      
