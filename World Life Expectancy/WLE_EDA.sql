select * from world_life_expectancy;

select status, count(distinct(country)), round(avg(`Life expectancy`),1)
from world_life_expectancy
group by Status;

select country, round(avg(BMI),1) as BMI, round(sum(`Adult mortality`),1) as Adult_Mortality,
		round(avg(`Life expectancy`),1) as Life_Expectancy
from world_life_expectancy
where BMI > 0 and `Life expectancy` > 0
group by country
order by round(avg(BMI),1) desc; 