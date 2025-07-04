use WeatherData

select * from [Weather History Table];
exec sp_help '[Weather History Table]'  -- like Describe tablename

select count(*) as Total_rows from [Weather History Table]

exec sp_rename '[Weather History Table].Date','W_Date','column'; -- rename the column
exec sp_rename '[Weather History Table].Time','W_Time','column'; -- rename the column
exec sp_rename '[Weather History Table].Month','W_Month','column'; -- rename the column
exec sp_rename '[Weather History Table].Year','W_Year','column'; -- rename the column


-- 1. What is the average temperature for each month?

select 
	Datename(Month, w_Date) AS Month_wise,
	month(w_date) AS MonthNumber,
	avg(Avg_temperature_C) as Average_Temperature
from [Weather History Table]
group by month(w_date), datename(MONTH, w_date)
order by MonthNumber;

-- 2. Which day had the highest & lowest average temperature?

select w_date,round(Avg_Temperature_C,2) as Highest_Temperature
from [Weather History Table]
where Avg_Temperature_C = (select max(Avg_Temperature_C) from [Weather History Table]);

select w_date, round(Avg_Temperature_C,4) as Lowest_Temperature
from [Weather History Table]
where Avg_Temperature_C = (select min(Avg_Temperature_C) from [Weather History Table]);

'''(
select w_month,round(Avg_Temperature_C,2) as Highest_Temperature
from [Weather History Table]
where Avg_Temperature_C = (select max(Avg_Temperature_C) from [Weather History Table]);

select w_month, round(Avg_Temperature_C,4) as Lowest_Temperature
from [Weather History Table]
where Avg_Temperature_C = (select min(Avg_Temperature_C) from [Weather History Table]);
)'''

-- 3. What is the average Humidity and Wind speed

select 
	round(avg(Humidity),2) as Average_Humidity,
	round(avg(Wind_speed_km_h),2) as Average_Windspeed
from [Weather History Table];


-- 4. How many days were above or below a certain temperature (35C)
select count(*) as Days_above_35C
from [Weather History Table]
where Avg_Temperature_C>35;

select count(*) as Days_above_35C
from(
	select
    W_Date,
    AVG(Avg_Temperature_C) as AvgTemp
from [Weather History Table]
where Avg_Temperature_C > 35
group by W_Date
) as subquery;

select W_Date, W_Time, Avg_Temperature_C
from [Weather History Table]
where W_Date='2006-06-27'

select * from [Weather History Table];

-- 5. What are the top 10 hottest and coldest day?

SELECT TOP 10
    CAST([W_Date] AS DATE) AS day,
    AVG(Avg_temperature_C) AS daily_avg_temp
FROM [Weather History Table]
GROUP BY CAST([W_Date] AS DATE)
ORDER BY daily_avg_temp DESC;


SELECT top 10
    CAST([W_Date] AS DATE) AS day,
    AVG(Avg_temperature_C) AS daily_avg_temp
FROM [Weather History Table]
GROUP BY CAST([W_Date] AS DATE)
ORDER BY daily_avg_temp asc;

-- 6. Is there a correlatin between temperature and humidity? 
-- Yes. It has strong negative correlation -0.63
SELECT
    (
        COUNT(*) * SUM(Avg_Temperature_C * Humidity) 
        - SUM(Avg_Temperature_C) * SUM(Humidity)
    ) * 1.0 /
    SQRT(
        (COUNT(*) * SUM(Avg_Temperature_C * Avg_Temperature_C) - POWER(SUM(Avg_Temperature_C), 2)) *
        (COUNT(*) * SUM(Humidity * Humidity) - POWER(SUM(Humidity), 2))
    ) AS Correlation_Temp_Humidity
FROM [Weather History Table]
WHERE Avg_Temperature_C IS NOT NULL AND Humidity IS NOT NULL;

-- 7. What is the temperature variation (difference between max and min temp) in each month?
select 
	Datename(Month, w_Date) AS Month_wise,
	month(w_date) AS MonthNumber,
	avg(Temperature_Difference) as Temperature_variation
from [Weather History Table]
group by month(w_date), datename(MONTH, w_date)
order by MonthNumber;

-- 8. How many days had "Rainy" weather (based on weather_condition)?
select count(*) from [Weather History Table] where Precip_Type in ('rain')

-- 9. What is the average temperature for each type of weather condition?

select
	Summary,
	avg(Avg_Temperature_C) as Avg_Temp_Based_weathercond
from [Weather History Table] 
group by Summary
order by Summary asc;

 -- 10. Which day(s) in April 2006 had the lowest visibility and what was the weather summary?

select W_Date, W_Month, W_Year, Visibility_km, Summary
from [Weather History Table]
where W_Year = 2006 and W_Month = 'April'
  and Visibility_km = (
    select min(Visibility_km)
    from [Weather History Table]
    where W_Year = 2006 and W_Month = 'April'
);

