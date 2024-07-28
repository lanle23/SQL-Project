-- DATA CLEANING
-- LINK TO DATA: https://www.kaggle.com/datasets/swaptr/layoffs-2022
SELECT *
FROM layoffs;

-- 1. Remove Duplicates (Loại bỏ lặp)
-- 2. Standardize the DATA (Chuẩn hóa dữ liệu)
-- 3. Null Values or blank values
-- 4. Remove any columns or rows

# create a copy table layoffs - layoffs_staging
CREATE TABLE layoffs_staging LIKE layoffs;
SELECT * FROM layoffs_staging;

INSERT layoffs_staging  
SELECT * FROM layoffs;

-- 1. Remove Duplicates (Loại bỏ lặp)

-- TẠO RA ROW_NUM ĐỂ DỄ DÀNG KTRA LẶP

SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised) AS row_num
FROM layoffs_staging
;

-- row_num > 1 -> lặp

WITH duplicate_cte AS
(
SELECT *, 
ROW_NUMBER() OVER( PARTITION BY company, location, industry, 
								total_laid_off, percentage_laid_off, `date`, 
								stage, country, funds_raised) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

-- check 
SELECT *
FROM layoffs_staging
WHERE company = 'Cazoo';



CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` text,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised` double DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *, 
ROW_NUMBER() OVER( PARTITION BY company, location, industry, 
								total_laid_off, percentage_laid_off, `date`, 
								stage, country, funds_raised) AS row_num
FROM layoffs_staging;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- Delete duplicates
DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num > 1;

-- 2. Standardize the DATA (Chuẩn hóa dữ liệu)
-- company
SELECT company, TRIM(company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET company = TRIM(company);

-- industry
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1; -- 1 =  industry

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'http%';

SELECT *
FROM layoffs_staging2
WHERE company = 'eBay';

UPDATE layoffs_staging2 
SET industry = 'Retail'
WHERE industry LIKE 'http%';


-- location
SELECT DISTINCT location
FROM layoffs_staging2
ORDER BY 1;

-- country
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;


-- date

-- if date like: m/d/y(text)
-- SELECT `date`,
-- STR_TO_DATE(`date`, "%m%d%Y")
-- FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;


-- 3. Null Values or blank values

SELECT *
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE industry = '' OR industry IS NULL;

SELECT *
FROM layoffs_staging2
WHERE company = 'Appsmith';


SELECT *
FROM layoffs_staging2
WHERE total_laid_off = '' -- OR total_laid_off IS NULL
AND percentage_laid_off = '' -- OR percentage_laid_off IS NULL
;

DELETE
FROM layoffs_staging2
WHERE total_laid_off = '' 
AND percentage_laid_off = '';

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num; -- 4. Remove any columns or rows

SELECT *
FROM layoffs_staging2;
