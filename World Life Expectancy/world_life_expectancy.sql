-- Query 1: Count the number of records in the world_life_expectancy table
-- This helps ensure that the number of records matches the count in the CSV file used for import.

 SELECT 
    COUNT(*)
FROM
    world_life_expectancy;

    
-- Query 2: Display all records from the world_life_expectancy table
-- This query retrieves and shows all the columns and rows in the table to review the dataset.

SELECT 
    *
FROM
    world_life_expectancy;
 
 
 
 
 

-- Query 3: Check for duplicate records based on country and year
-- This query identifies duplicate records by checking for multiple entries with the same country and year.
-- 
-- Explanation:
-- 1. The inner query generates a concatenated value of the country and year columns to identify duplicates.
-- 2. ROW_NUMBER() is used with PARTITION BY to assign a unique rank to each row within the partition of concatenated country and year values.
--    - Rows with the same country and year will receive a sequential number starting from 1.
-- 3. The outer query filters for rows where the rank is greater than 1, which indicates duplicates.

SELECT *
FROM
(
    SELECT 
        country,
        year,
        ROW_ID,
        CONCAT(country, year) AS concat_key, -- Generate a concatenated key of country and year
        ROW_NUMBER() OVER (PARTITION BY CONCAT(country, year) ORDER BY ROW_ID) AS ranked -- Assign row numbers within each partition
    FROM
        world_life_expectancy
) AS assign_row_num
WHERE ranked > 1; -- Filter out only the duplicate rows







-- Query 4: Remove duplicate records from world_life_expectancy
-- This query deletes rows that have duplicate entries based on country and year.
--
-- Explanation:
-- 1. The inner query generates row numbers for records with the same country and year.
-- 2. Records with a rank greater than 1 are considered duplicates.
-- 3. The outer query selects the ROW_IDs of these duplicate records.
-- 4. The DELETE statement removes rows from the table where the ROW_ID matches any of the selected duplicate ROW_IDs.

delete from world_life_expectancy
where ROW_ID in (
	select ROW_ID
	from
	(
		select *
		from
		(
			SELECT 
				country,
				year,
				ROW_ID,
				CONCAT(country, year), -- Generate a concatenated key of country and year
				ROW_NUMBER() over (partition by CONCAT(country, year)) as ranked -- Assign row numbers within each partition
			FROM
				world_life_expectancy) as assign_row_num

where ranked > 1) as get_row_id);  -- Select duplicate rows




    
    
-- Query 5: Find empty cells in the status column and calculate possible values
-- This query identifies rows with empty status values and attempts to fill them based on adjacent rows' status values.
-- 
-- Explanation:
-- 1. The Common Table Expression (CTE) `lag_lead_status` calculates the previous and next status values for each row.
--    - `LAG(status)` retrieves the status from the previous row within the same country, ordered by year.
--    - `LEAD(status)` retrieves the status from the next row within the same country, ordered by year.
-- 2. The main query uses these previous and next status values to fill in empty status cells:
--    - If the previous status is not empty, it is used as the updated status.
--    - If the previous status is empty but the next status is not empty, the next status is used.
--    - If both previous and next statuses are empty, the status remains empty.
-- 3. The `WHERE` clause filters the results to only include rows where the status is empty.

WITH lag_lead_status AS (
    SELECT 
        country,
        year,
        status,
        ROW_ID,
        LAG(status) OVER (PARTITION BY country ORDER BY year) AS previous_status, -- Previous row's status within the same country
        LEAD(status) OVER (PARTITION BY country ORDER BY year) AS next_status -- Next row's status within the same country
    FROM 
        world_life_expectancy
)
SELECT 
    ROW_ID,
    CASE 
        WHEN previous_status <> '' THEN previous_status -- Use previous status if it is not empty
        WHEN next_status <> '' THEN next_status -- Use next status if previous status is empty
        ELSE '' -- Leave status empty if both previous and next statuses are empty
    END AS updated_status
FROM 
    lag_lead_status
WHERE 
    status = ''; -- Filter rows where status is currently empty







-- Query 6: Update the original table with calculated updated_status values
-- This query updates the status column in the `world_life_expectancy` table using values derived from adjacent rows.
--
-- Explanation:
-- 1. The subquery (with CTE) calculates the updated status for rows where the status is currently empty.
--    - It uses `LAG()` and `LEAD()` functions to get previous and next status values.
--    - The `CASE` statement determines the updated status:
--      - Uses the previous status if it is not empty.
--      - Uses the next status if the previous status is empty.
--      - Leaves the status empty if both previous and next statuses are empty.
-- 2. The `JOIN` operation links the original table `wle` with the subquery results using `ROW_ID`.
-- 3. The `UPDATE` statement sets the `status` in the original table to the `updated_status` from the subquery where the current status is empty.

UPDATE world_life_expectancy wle
JOIN (
    WITH lag_lead_status AS (
        SELECT 
            country,
            year,
            status,
            ROW_ID,
            LAG(status) OVER (PARTITION BY country ORDER BY year) AS previous_status, -- Previous row's status within the same country
            LEAD(status) OVER (PARTITION BY country ORDER BY year) AS next_status -- Next row's status within the same country
        FROM 
            world_life_expectancy
    )
    SELECT 
        ROW_ID,
        CASE 
            WHEN previous_status <> '' THEN previous_status -- Use previous status if it is not empty
            WHEN next_status <> '' THEN next_status -- Use next status if previous status is empty
            ELSE '' -- Leave status empty if both previous and next statuses are empty
        END AS updated_status
    FROM 
        lag_lead_status
    WHERE 
        status = '' -- Filter rows where status is currently empty
) AS updated
ON wle.ROW_ID = updated.ROW_ID -- Join on the unique ROW_ID
SET wle.status = updated.updated_status -- Update the status column with the calculated value
WHERE wle.status = ''; -- Only update rows where the status is currently empty





-- Query 7: Calculate updated life expectancy values for missing entries
-- This query fills in missing life expectancy values by averaging the previous and next values,
-- taking into account that life expectancy tends to increase slightly each year.

-- Explanation:
-- 1. The Common Table Expression (CTE) `lag_lead_life_value` calculates the previous and next life expectancy values for each row.
--    - `LAG(`Life expectancy`)` retrieves the life expectancy from the previous row, sorted by year in descending order.
--    - `LEAD(`Life expectancy`)` retrieves the life expectancy from the next row, sorted by year in descending order.
-- 2. The main query calculates the `updated_life_value`:
--    - If both previous and next life expectancy values are available, their average is calculated and rounded to 1 decimal place.
--    - If only the previous value is available, it is used as the updated value (rounded to 1 decimal place).
--    - If only the next value is available, it is used as the updated value (rounded to 1 decimal place).
--    - If neither value is available, the result is set to `NULL`.
-- 3. The `WHERE` clause filters the results to only include rows where the `Life expectancy` is currently missing.

WITH lag_lead_life_value AS (
    SELECT 
        country,
        year,
        status,
        `Life expectancy`,
        ROW_ID,
        LAG(`Life expectancy`) OVER (PARTITION BY country ORDER BY year DESC) AS previous_life_value, -- Previous life expectancy within the same country
        LEAD(`Life expectancy`) OVER (PARTITION BY country ORDER BY year DESC) AS next_life_value -- Next life expectancy within the same country
    FROM 
        world_life_expectancy
)
SELECT 
    ROW_ID,
    CASE
        WHEN previous_life_value <> '' AND next_life_value <> '' THEN -- Both previous and next values are available
            ROUND((previous_life_value + next_life_value) / 2, 1) -- Calculate average and round to 1 decimal place
        WHEN previous_life_value <> '' THEN -- Only previous value is available
            ROUND(previous_life_value, 1) -- Use previous value rounded to 1 decimal place
        WHEN next_life_value <> '' THEN -- Only next value is available
            ROUND(next_life_value, 1) -- Use next value rounded to 1 decimal place
        ELSE 
            NULL -- No values available
    END AS updated_life_value
FROM 
    lag_lead_life_value
WHERE 
    `Life expectancy` = ''; -- Filter rows where life expectancy is currently missing

    
    
    
    
    
-- Query 8: Update the life expectancy values in the original table
-- This query updates the `Life expectancy` column in the `world_life_expectancy` table using calculated values from adjacent rows.

-- Explanation:
-- 1. The subquery (with CTE) calculates the updated life expectancy for rows where the life expectancy is currently missing.
--    - It uses `LAG()` and `LEAD()` functions to get the previous and next life expectancy values within the same country, ordered by year in descending order.
--    - The `CASE` statement determines the `updated_life_value`:
--      - If both previous and next values are available, their average is computed and rounded to 1 decimal place.
--      - If only the previous value is available, it is used as the updated value (rounded to 1 decimal place).
--      - If only the next value is available, it is used as the updated value (rounded to 1 decimal place).
--      - If neither value is available, the result is set to `NULL`.
-- 2. The `JOIN` operation links the original table `wle` with the subquery results using `ROW_ID`.
-- 3. The `UPDATE` statement sets the `Life expectancy` column in the original table to the `updated_life_value` from the subquery.
-- 4. The `WHERE` clause ensures that only rows with missing life expectancy values are updated.

UPDATE world_life_expectancy wle
JOIN (
    WITH lag_lead_life_value AS (
        SELECT 
            country,
            year,
            status,
            `Life expectancy`,
            ROW_ID,
            LAG(`Life expectancy`) OVER (PARTITION BY country ORDER BY year DESC) AS previous_life_value, -- Previous life expectancy within the same country
            LEAD(`Life expectancy`) OVER (PARTITION BY country ORDER BY year DESC) AS next_life_value -- Next life expectancy within the same country
        FROM 
            world_life_expectancy
    )
    SELECT 
        ROW_ID,
        CASE 
            WHEN previous_life_value <> '' AND next_life_value <> '' THEN -- Both previous and next values are available
                ROUND((previous_life_value + next_life_value) / 2, 1) -- Average of both values, rounded to 1 decimal place
            WHEN previous_life_value <> '' THEN -- Only previous value is available
                ROUND(previous_life_value, 1) -- Use previous value, rounded to 1 decimal place
            WHEN next_life_value <> '' THEN -- Only next value is available
                ROUND(next_life_value, 1) -- Use next value, rounded to 1 decimal place
            ELSE 
                NULL -- No values available
        END AS updated_life_value
    FROM 
        lag_lead_life_value
    WHERE 
        `Life expectancy` = '' -- Filter rows where life expectancy is currently missing
) AS updated_life
ON wle.ROW_ID = updated_life.ROW_ID -- Join on the unique ROW_ID
SET wle.`Life expectancy` = updated_life.updated_life_value -- Update the life expectancy column with the calculated value
WHERE wle.`Life expectancy` = ''; -- Only update rows where the life expectancy is currently missing

