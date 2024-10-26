Delimiter $$
drop procedure if exists copy_and_clean_data $$
create procedure copy_and_clean_data()

Begin
	-- Create a new table
    DROP TABLE if exists `cleaned_us_household_income`;
	CREATE TABLE `cleaned_us_household_income` (
		`row_id` INT DEFAULT NULL,
		`id` INT DEFAULT NULL,
		`State_Code` INT DEFAULT NULL,
		`State_Name` TEXT,
		`State_ab` TEXT,
		`County` TEXT,
		`City` TEXT,
		`Place` TEXT,
		`Type` TEXT,
		`Primary` TEXT,
		`Zip_Code` INT DEFAULT NULL,
		`Area_Code` INT DEFAULT NULL,
		`ALand` BIGINT DEFAULT NULL,
		`AWater` BIGINT DEFAULT NULL,
		`Lat` DOUBLE DEFAULT NULL,
		`Lon` DOUBLE DEFAULT NULL,
		`Timestamp` DATETIME DEFAULT NULL
	)  ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE = UTF8MB4_0900_AI_CI;
    
    -- Copy Data from Original table
    Insert into cleaned_us_household_income
    select *, current_timestamp()
    from us_household_income;
    
    -- Cleaning the data
    delete from cleaned_us_household_income
    where row_id in (
				select row_id
                from (
					select row_id, id,
                    row_number() over (
						partition by id, `Timestamp` order by id) as row_num
					from cleaned_us_household_income) duplicates
                    where row_num > 1 
                    );
                    
	-- Standardizing the data
    update cleaned_us_household_income
    set state_name = "Georgia"
    where state_name = "georia";
    
    update cleaned_us_household_income
    set County = upper(County);
    
    update cleaned_us_household_income
    set City = upper(City);
    
    update cleaned_us_household_income
    set Place = upper(Place);
    
    update cleaned_us_household_income
    set State_Name = upper(State_Name);
    
    update cleaned_us_household_income
    set `Type` = "CDP"
    where `Type` = "CPD";
    
    update cleaned_us_household_income
    set `Type` = "Borough"
    where `Type` = "Boroughs";
    

END $$
delimiter ;

call copy_and_clean_data();

create event run_cleaning_procedure
	on schedule every 10 day
    do call copy_and_clean_data();


