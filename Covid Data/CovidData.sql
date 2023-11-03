--checking if the dataset uploaded succefully 

select * from portfolio.dbo.covdeaths
order by location


-- i notice that the data get upload by 65535 rows only so i divide the data to 2 tables and i'm gonna create a table of the union of the 2 tables . 

select * 
into CovDeaths
from (
      select *
	  from portfolio.dbo.coviddeaths
      union
	       select * 
		   from portfolio.dbo.CovidDeaths2 )
		   a

 select * from CovDeaths
 order by location

--- after we create the table now lets delete the two first tables 

drop table dbo.CovidDeaths
drop table dbo.CovidDeaths2


--cheking some datatype if it still int or it get coverted to some varchar while the uploading 

select location ,date ,(total_deaths/total_cases)*100 as DeathPercentage  , population
from Portfolio.dbo.CovDeaths
where location like 'mor%'
order by date

select location , date , total_cases , population , (total_cases/population)*100 as infect_Percentage
from Portfolio..CovDeaths
order by date


 --the highest countries infection rate compared to the population
 select location , population , max(total_cases) as highest_infection_count , max( (total_cases/population)*100) as max_infect_Percentage
 from Portfolio..CovDeaths
 group by location , population
 order by max_infect_Percentage desc

 --the countries with the highest death count 
  select location ,max(total_deaths) as Total_Death_Count
 from Portfolio..CovDeaths
 where continent is not NULL 
 group by location 
 order by Total_Death_Count desc


  --the countries with the highest death count per population
  select location ,max(cast(total_deaths as int)) as Total_Death_Count
 from Portfolio..CovDeaths
 where continent is not NULL 
 group by location 
 order by Total_Death_Count desc


-- showing continent with high death count 


  select continent ,max(cast(total_deaths as int)) as Total_Death_Count
 from Portfolio..CovDeaths
 where continent is not NULL 
 group by continent 
 order by Total_Death_Count desc


 --global numbers


 select date ,sum(new_cases)as total_new_cases,sum(new_deaths) as total_new_deaths, (sum(new_deaths)/sum(new_cases))*100 as new_deaths_percentage
 from Portfolio.dbo.CovDeaths
where continent is not null
group by date
order by 1,2 


-- checking Vaccinations table ( i notice that i import the table to a wrong database so i copy it to the correct database )


--select * 
--INTO portfolio.dbo.CovVacc
--from (
--select * from master.CovVacc
--) a

select * from portfolio.dbo.CovVacc
where new_vaccinations <>0
order by location


-- total Population Vs vaccinations

select death.continent , death.location,death.date,death.population,vac.new_vaccinations , 
sum(vac.new_vaccinations) over (partition by death.location)
from portfolio..CovDeaths Death
join portfolio..CovVacc Vac
on death.location = Vac.location 
and death.date = Vac.date
where death.continent is not NULL
order by 2,3


--the increase of vaccination percentage in every country


with PercVac (continent,location,date,population,new_vaccinations,Total_People_vacc)
as (
select death.continent , death.location,death.date,death.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by death.location order by death.location , death.date) as Total_People_vacc
from portfolio..CovDeaths Death
join portfolio..CovVacc Vac
on death.location = Vac.location 
and death.date = Vac.date
where death.continent is not NULL
--order by 2,3
)
 select *, (Total_People_vacc/population)*100 from PercVac 


 -- creating a temp table 

 create table portfolio.dbo.Percvacc(
 continent varchar(255),
 location varchar(255),
 date datetime ,
 population numeric,
 new_vaccinations numeric,
 Total_People_vacc numeric
 )
 insert into portfolio..PercVacc
 select death.continent , death.location,death.date,death.population, vac.new_vaccinations,
sum(vac.new_vaccinations) over (partition by death.location order by death.location , death.date) as Total_People_vacc
from portfolio..CovDeaths Death
join portfolio..CovVacc Vac
on death.location = Vac.location 
and death.date = Vac.date
where death.continent is not NULL


--the countries with the highest vaccination percentage


select location,population,max(total_people_vacc) as total_vacc ,(max(total_people_vacc)/population)*100 
from portfolio.dbo.Percvacc
group by location , population
order by max(total_people_vacc) desc
