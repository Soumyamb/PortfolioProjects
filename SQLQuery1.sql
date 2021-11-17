Select *
from ['cases$']


--
Select location,date,(total_deaths/total_cases)*100 as DeathPercentage
from ['cases$']
where location like 'Germany'
order by DeathPercentage

--Looking at countries with highest infection date compared to population

Select location,population, MAX(total_cases) as HighestInfection,MAX((total_cases/population)*100) as PerHighestInfection
from ['cases$']
where continent is not null
group by location, population
order by HighestInfection,PerHighestInfection desc


--Showing continents with highest deaths
Select continent, MAX(cast(total_deaths as int)) as HighestDeaths
from ['cases$']
group by continent
order by HighestDeaths desc

--Showing countries with Highest Deaths
Select location, MAX(cast(total_deaths as int)) as HighestDeaths
from ['cases$']
where continent is not null
group by location
order by HighestDeaths desc

--Breaking global numbers

Select  SUM(new_cases) as newcases_global, SUM(cast(new_deaths as int)) as new_deaths_global
from ['cases$']

-- JOINING THE TABLES

Select * 
from ['cases$'] as cases
Join ['vac$'] as vac
On vac.date=cases.date
and cases.location=vac.location

--Looking Population vs Vaccination

with PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
as
(
Select cases.continent, cases.location, cases.date, cases.population, vac.new_vaccinations, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by cases.location order by cases.location, cases.date) as RollingPeopleVaccinated
from ['cases$']  as cases
Join ['vac$']  as vac
     On vac.date=cases.date
	and cases.location=vac.location
where cases.continent is not null
)

Select *, RollingPeopleVaccinated/Population *100 as PercentageRollingPeopleVaccinated
from PopvsVac






