 SELECT * from PortfolioProject.dbo.CovidDeaths 
 where continent is not null 
 order by 3,4;

--SELECT * from PortfolioProject.dbo.CovidVaccinations
--order by 3,4;


select location,date, total_cases, new_cases, total_deaths,population 
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2;

select location, date, total_cases, total_deaths,(total_deaths / total_cases) * 100 as DeathPercent -- shows death percentage 
from PortfolioProject..CovidDeaths
where location like '%India%'
and continent is not null
order by 1,2;

select location, date, total_cases, population,(total_cases/population) * 100 as casePercent  --shows case percentage
from PortfolioProject..CovidDeaths
--where location like '%India%'
where continent is not null
order by 1,2;

select location, population,max(total_cases) as Highest_infection_count, max((total_cases/population))*100 as Highest_Infection_countPercent
from PortfolioProject..CovidDeaths 
--where location like'%india%'
group by location, population
order by Highest_Infection_countPercent desc;

select location, population,date ,max(total_cases) as Highest_infection_count, max((total_cases/population))*100 as Highest_Infection_countPercent
from PortfolioProject..CovidDeaths 
--where location like'%india%'
group by location, population,date
order by Highest_Infection_countPercent desc;

--showing with the highest death count per population

select location, sum(cast( new_deaths as int)) as total_death_count
from PortfolioProject..CovidDeaths 
--where location like'%india%'
where continent is null
and location not in( 'World', 'International', 'European Union')
group by location
order by total_death_count desc;

select  sum(new_cases) as total_cases ,sum(cast(new_deaths as int)) as total_deaths ,sum(cast(new_deaths as int ))/sum(new_cases) * 100 as DeathPercent -- shows death percentage 
from PortfolioProject..CovidDeaths
--where location like '%India%'
where continent is not null

--group by date
order by 1,2;


select dea.location, dea.continent, dea.population, dea.date, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as cumulative_vaccinations
--(cumulative_vaccinations/population)*100 as vacpercent
from PortfolioProject..CovidDeaths dea
     join PortfolioProject..CovidVaccinations vac
	 on dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	 order by 1,2,3,4


	 --WITH CTE

	 with PopvsVac (continent,location, date,  population,new_vaccinations, cumulative_vaccinations) as
	 (
	 select  dea.continent,dea.location, dea.date, dea.population,  vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as cumulative_vaccinations
--(cumulative_vaccinations/population)*100 as vacpercent
from PortfolioProject..CovidDeaths dea
     join PortfolioProject..CovidVaccinations vac
	 on dea.location = vac.location
	 and dea.date = vac.date
	 where dea.continent is not null
	-- order by 1,2,3,4
	 )

	 select *, (cumulative_vaccinations/population)*100 as VacPercent
	 from PopvsVac

	 -- temp table
	 drop table if exists #percentpopulationvaccinated
	 create table #percentpopulationvaccinated
	 (
	 continent nvarchar(255),
	 location nvarchar(255), 
	 date datetime,
	 population numeric,
	 new_vaccinated numeric,
	 cumulative_vaccinations numeric
	 )

	 insert into #percentpopulationvaccinated


	 select  dea.continent,dea.location, dea.date, dea.population,  vac.new_vaccinations,
    sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as cumulative_vaccinations

     from PortfolioProject..CovidDeaths dea
     join PortfolioProject..CovidVaccinations vac
	 on dea.location = vac.location
	 and dea.date = vac.date
	 --where dea.continent is not null
	-- order by 1,2,3,4
	 

	 select *, (cumulative_vaccinations/population)*100 as VacPercent
	 from #percentpopulationvaccinated

	-- drop view if exists percentpopulationvaccinated

	 USE PortfolioProject;
GO

CREATE VIEW PercentPopulationVaccinated AS 
SELECT 
    dea.continent,
    dea.location,
    dea.date,
    dea.population,  
    vac.new_vaccinations,
    SUM(CAST(vac.new_vaccinations AS BIGINT)) OVER (
        PARTITION BY dea.location 
        ORDER BY dea.location, dea.date
    ) AS cumulative_vaccinations
FROM 
    PortfolioProject..CovidDeaths dea
JOIN 
    PortfolioProject..CovidVaccinations vac
ON 
    dea.location = vac.location
AND 
    dea.date = vac.date
WHERE 
    dea.continent IS NOT NULL;
GO

	 