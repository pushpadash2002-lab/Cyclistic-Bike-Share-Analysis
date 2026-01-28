Use [BikeSharing Compnay Data]
SELECT * FROM dbo.Trips_2020_Q1
--Creating new table joining two tables

SELECT 
CAST(ride_id AS nvarchar(50)) AS ride_id,
started_at,
ended_at,
CAST(rideable_type AS nvarchar(50)) AS rideable_type,
start_station_name,
CAST(start_station_id AS nvarchar(50)) AS start_station_id,
end_station_name,
CAST(end_station_id AS nvarchar(50)) AS end_station_id,
CAST(member_casual AS nvarchar(50)) AS member_casual
INTO combined_trips
FROM dbo.Trips_2020_Q1

INSERT INTO combined_trips(ride_id,started_at,ended_at,rideable_type,start_station_id,end_station_id,start_station_name,end_station_name,member_casual)
SELECT 
CAST(trip_id AS nvarchar(50)),
start_time,
end_time,
CAST(bikeid AS nvarchar(50)),
CAST(from_station_id AS nvarchar(50)),
from_station_name,
CAST(to_station_id AS nvarchar(50)),
to_station_name,
CASE 
WHEN usertype ='Subscriber' THEN 'member'
WHEN usertype = 'Customer' THEN 'casual'
END
FROM dbo.Trips_2019_Q1


--Calculating day of the week
SELECT ride_id,
member_casual,
started_at,
ended_at,
DATEDIFF(SECOND,started_at,ended_at)/60.0 AS ride_length,
DATEPART(WEEKDAY,started_at) AS day_of_week,
DATEPART(MONTH,started_at) AS month_start
INTO cleaned_trips
FROM combined_trips
WHERE DATEDIFF(SECOND,started_at,ended_at)>60 
AND DATEDIFF(SECOND,started_at,ended_at) <86400
-- Calculate the average ride duration and compare between member and casual
SELECT 
member_casual,
AVG(ride_length) AS avg_ride_duration,
MAX(ride_length) AS max_duration,
MIN(ride_length) AS min_duration
FROM cleaned_trips
GROUP BY member_casual

--Which days of the week each group is most active
SELECT
member_casual,
day_of_week,
COUNT(*) AS total_rides,
AVG(ride_length) AS avg_duration
FROM cleaned_trips
GROUP BY member_casual,day_of_week
ORDER BY member_casual,day_of_week

--Top 5 start station for casual riders
SELECT TOP 5
start_station_name,
COUNT(*) AS ride_count
FROM cleaned_trips
WHERE member_casual = 'casual'
GROUP BY start_station_name
ORDER BY ride_count DESC

--Summary for executive team
SELECT
member_casual,
day_of_week,
COUNT(*) AS number_of_rides,
AVG(ride_length) AS avg_ride_length
FROM cleaned_trips
GROUP BY member_casual,day_of_week

--Getting the station data
SELECT TOP 10
start_station_name,
COUNT(*) AS number_of_rides
FROM cleaned_trips
WHERE member_casual='casual'
GROUP BY start_station_name
ORDER BY number_of_rides DESC

