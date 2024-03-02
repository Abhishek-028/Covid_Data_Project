select * from CovidDeaths


Select continent ,Location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Where continent is not null 
order by 1,2


-- Showing summary statistics of total_cases and total_deaths
SELECT 
    MIN(cast(total_cases as numeric)) AS min_total_cases,
    MAX(cast(total_cases as numeric)) AS max_total_cases,
    AVG(cast(total_cases as numeric)) AS avg_total_cases,
    MIN(cast(total_deaths as numeric)) AS min_total_deaths,
    MAX(cast(total_deaths as numeric)) AS max_total_deaths,
    AVG(cast(total_deaths as numeric)) AS avg_total_deaths
FROM CovidDeaths;


-- Show total cases and total deaths by continent
SELECT Continent, SUM(cast(total_cases as numeric)) AS total_cases, SUM(cast(total_deaths as numeric)) AS total_deaths,
(SUM(cast(total_deaths as numeric))/SUM(cast(total_cases as numeric)))*100 as DeathPercent
FROM CovidDeaths
where continent is not null
GROUP BY Continent;


-- Show total cases and total deaths by location for a specific continent
SELECT Location, SUM(cast(total_cases as numeric)) AS total_cases, SUM(cast(total_deaths as numeric)) AS total_deaths
FROM CovidDeaths
WHERE Continent = 'Europe' 
GROUP BY Location
ORDER BY total_cases DESC;


-- Compare the total cases and total deaths between two continents
SELECT 
    Continent,
    SUM(cast(total_cases as numeric)) AS total_cases,
     SUM(cast(total_deaths as numeric)) AS total_deaths,
	 (SUM(cast(total_deaths as numeric))/SUM(cast(total_cases as numeric)))*100 as DeathPercent
FROM CovidDeaths
WHERE Continent IN ('Europe', 'North America')
GROUP BY Continent;

--Vaccination Analyzation
Select * from CovidVaccination


--Total number of tests conducted in each continent:
SELECT 
    Continent,
    SUM(cast(total_tests as numeric)) AS TotalTests
FROM covidvaccination 
GROUP BY Continent
Order by TotalTests desc



-- Shows Percentage of Population that has recieved at least one Covid Vaccine

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated 
From CovidDeaths dea
Join CovidVaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
order by 2,3




-- CTE to calculate the total cases and total deaths by continent
WITH ContinentSummary AS (
    SELECT 
        Continent,
        SUM(cast(total_cases as numeric)) AS total_cases,
        SUM(cast(total_deaths as numeric)) AS total_deaths,
		(SUM(cast(total_deaths as numeric))/SUM(cast(total_cases as numeric)))*100 as DeathPercent

    FROM CovidDeaths
    GROUP BY Continent
)

SELECT * FROM ContinentSummary where continent is not null order by DeathPercent desc;


-- Create a local temporary table to store the continents with the highest total cases
Drop table if exists #TopContinents
CREATE TABLE #TopContinents (
    Continent VARCHAR(255),
    total_cases numeric
);

-- Insert data into the temporary table
INSERT INTO #TopContinents (Continent, total_cases)
    SELECT 
        Continent,
        SUM(cast(total_cases as numeric)) AS total_cases
    FROM CovidDeaths
	where Continent is not null
    GROUP BY Continent
    ;

SELECT * FROM #TopContinents ORDER BY total_cases DESC;
