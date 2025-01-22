


 Data Preparation and Cleaning Steps for `customer_sweepstakes` Table

 1. Renaming Columns
 Query:  
  ```sql
  ALTER TABLE customer_sweepstakes RENAME COLUMN `ï»¿sweepstake_id` TO `sweepstake_id`;
  ```
 Purpose:  
  Fix encoding issues in column names and rename `ï»¿sweepstake_id` to `sweepstake_id` for better readability.



 2. Identifying Duplicates
 Query:  
  ```sql
  SELECT customer_id, COUNT(customer_id) 
  FROM customer_sweepstakes 
  GROUP BY customer_id 
  HAVING COUNT(customer_id) > 1;
  ```
 Purpose:  
  Identify duplicate `customer_id` entries for further cleaning.



 3. Deleting Duplicate Rows
 Query:  
  ```sql
  DELETE FROM customer_sweepstakes 
  WHERE sweepstake_id IN (
    SELECT sweepstake_id FROM (
      SELECT sweepstake_id, 
             ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY customer_id) AS row_num 
      FROM customer_sweepstakes
    ) AS row_table
    WHERE row_num > 1
  );
  ```
 Purpose:  
  Remove duplicate rows by retaining only the first instance of each `customer_id`.



 4. Standardizing Phone Numbers
 Step 1: Remove special characters from phone numbers.  
  ```sql
  UPDATE customer_sweepstakes 
  SET phone = REGEXP_REPLACE(phone, '[()/+]', '');
  ```
 Step 2: Reformat phone numbers into `XXXXXXXXXX` format.  
  ```sql
  UPDATE customer_sweepstakes 
  SET phone = CONCAT(SUBSTRING(phone, 1, 3), '', SUBSTRING(phone, 4, 3), '', SUBSTRING(phone, 7, 4)) 
  WHERE phone <> '';
  ```
 Purpose:  
  Ensure all phone numbers follow a consistent format.



 5. Standardizing Birth Dates
 Step 1: Convert multiple date formats to a uniform format.  
  ```sql
  UPDATE customer_sweepstakes 
  SET birth_date = IF(
    STR_TO_DATE(birth_date, "%m/%d/%Y") IS NOT NULL, 
    STR_TO_DATE(birth_date, "%m/%d/%Y"), 
    STR_TO_DATE(birth_date, "%Y/%d/%m")
  );
  ```
 Step 2: Standardize the date format to `DD/MM/YYYY`.  
  ```sql
  UPDATE customer_sweepstakes 
  SET birth_date = CONCAT(SUBSTRING(birth_date, 9, 2), '/', SUBSTRING(birth_date, 6, 2), '/', SUBSTRING(birth_date, 1, 4));
  ```
 Purpose:  
  Resolve inconsistencies in date formats for easier analysis.



 6. Normalizing Boolean Responses
 Query:  
  ```sql
  UPDATE customer_sweepstakes 
  SET `Are you over 18?` = CASE  
    WHEN `Are you over 18?` = "Yes" THEN "Y" 
    WHEN `Are you over 18?` = "No" THEN "N" 
    ELSE `Are you over 18?` 
  END;
  ```
 Purpose:  
  Convert `Yes/No` responses to `Y/N` for consistency.



 7. Splitting Address into Components
 Step 1: Add new columns for `street`, `city`, and `state`.  
  ```sql
  ALTER TABLE customer_sweepstakes 
  ADD COLUMN street VARCHAR(50) AFTER address, 
  ADD COLUMN city VARCHAR(50) AFTER street, 
  ADD COLUMN state VARCHAR(50) AFTER city;
  ```
 Step 2: Populate the new columns.  
  ```sql
  UPDATE customer_sweepstakes 
  SET street = SUBSTRING_INDEX(address, ',', 1), 
      city = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(address, ',', 2), ',', 1)), 
      state = UPPER(SUBSTRING_INDEX(address, ',', 1));
  ```
 Purpose:  
  Normalize the address data by splitting it into separate fields.



 8. Handling Null Values
 Query:  
  ```sql
  UPDATE customer_sweepstakes 
  SET phone = NULL 
  WHERE phone = '';
  ```
  ```sql
  UPDATE customer_sweepstakes 
  SET income = NULL 
  WHERE income = '';
  ```
 Purpose:  
  Replace empty strings with `NULL` for accurate analysis and better handling of missing values.



 9. Updating Age Validation
 Step 1: Identify customers under 18 and update their status.  
  ```sql
  UPDATE customer_sweepstakes 
  SET `Are you over 18?` = 'N' 
  WHERE (YEAR(NOW())  YEAR(birth_date)) < 18;
  ```
 Step 2: Update valid adult customers.  
  ```sql
  UPDATE customer_sweepstakes 
  SET `Are you over 18?` = 'Y' 
  WHERE (YEAR(NOW())  YEAR(birth_date)) >= 18;
  ```
 Purpose:  
  Ensure age validation aligns with birth dates.



 10. Dropping Unused Columns
 Query:  
  ```sql
  ALTER TABLE customer_sweepstakes DROP COLUMN address, DROP COLUMN favorite_color;
  ```
 Purpose:  
  Remove unnecessary columns to simplify the table.



 Final Output
At the end of these steps, the `customer_sweepstakes` table is clean, consistent, and optimized for further analysis. These transformations ensure data integrity and usability for business insights.
