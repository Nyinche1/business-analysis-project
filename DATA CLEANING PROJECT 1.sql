    --DATA CLEANING PROJECT 

SELECT *
FROM World_layoff.layoff_stagging  ;

SELECT * INTO World_layoff.layoff_stagging
FROM World_layoff.layoffs;

--REMOVE DUPLICATE 

WITH duplicate_cte as 
(SELECT *,ROW_NUMBER() OVER(PARTITION BY company,location,industry,total_laid_off,percentage_laid_off,[date],stage,country,funds_raised_millions ORDER BY company) as row_num
FROM World_layoff.layoff_stagging)
DELETE
FROM duplicate_cte 
WHERE row_num > 1;

--STANDARDISING DATA

SELECT company,TRIM(company)
FROM World_layoff.layoff_stagging;

UPDATE World_layoff.layoff_stagging
SET company = TRIM(company)
;

SELECT DISTINCT industry
FROM World_layoff.layoff_stagging
ORDER BY 1;

SELECT *
FROM World_layoff.layoff_stagging
WHERE industry LIKE 'Crypto%';

UPDATE World_layoff.layoff_stagging 
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT location
FROM World_layoff.layoff_stagging
ORDER BY 1;

SELECT DISTINCT country ,TRIM(TRAILING '.' FROM country)
FROM World_layoff.layoff_stagging
ORDER BY 1;

UPDATE World_layoff.layoff_stagging 
SET country = LEFT(country, LEN(country) - 1)
WHERE RIGHT(country, 1) = CHAR(10)
  AND country LIKE 'United States%';

UPDATE World_layoff.layoff_stagging 
SET  [date]=TRY_CONVERT(DATE, [date], 101) ;


-- NULL VALUES AND BLANK VALUE FORMATING

SELECT *
FROM World_layoff.layoff_stagging 
WHERE total_laid_off = 'NULL'
AND percentage_laid_off = 'NULL';

SELECT *
FROM World_layoff.layoff_stagging 
WHERE industry = 'NULL' OR industry = '';
 
SELECT *
FROM World_layoff.layoff_stagging ls 
WHERE company = 'airbnb';


SELECT *
FROM World_layoff.layoff_stagging t1
JOIN World_layoff.layoff_stagging t2
ON t1. company = t2. company
WHERE (t1. industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE t1
SET t1.industry = t2.industry
FROM World_layoff.layoff_stagging t1
JOIN World_layoff.layoff_stagging t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
  AND t2.industry IS NOT NULL;

UPDATE World_layoff.layoff_stagging 
SET industry = null 
WHERE industry = '';

SELECT *
FROM World_layoff.layoff_stagging 
WHERE percentage_laid_off = 'NULL' 
AND total_laid_off = 'NULL';

DELETE 
FROM World_layoff.layoff_stagging 
WHERE percentage_laid_off = 'NULL' 
AND total_laid_off = 'NULL';




