-- EXPLORATORY DATA ANALYSIS

SELECT *
FROM layoffs_staging2;

-- Looking at TOTAL, PERCENTAGE to see how big layoffs
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- To see which companies had 100% laid off
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
;

-- ORDER BY total_laid_of we can see how big funds raised of these companies
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised DESC
;
-- Britishvolt raised 2.4 billion dollars but had 100 % laid off -> bankrupt


-- Use GROUP BY

-- Companies with the most Total layoffs
SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC
-- LIMIT 5              # Take 5 companies (Amazon, Meta, Tesla, Microsoft, Google)
;

-- by location
SELECT location, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY location
ORDER BY 2 DESC
-- LIMIT 5              # Take 5 locations (SF Bay Area, Seattle, New York City, Bengaluru, Austin)
; 

-- by industry
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC
-- LIMIT 5              # Take 5 industries (Retail, Comsumer, Transportation, Other, Food)
;

-- by date(year)
SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC -- OR ORDER BY 1
;
-- 2023 > 2022 > 2024 > 2020 > 2021

-- by country
SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC
-- LIMIT 5              # Take 5 countries (U.S, India, Germany, U.K, Sweden)
						# we can see that U.S is the biggest total layoffs
;

-- by stage
SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC
-- LIMIT 5              # Take 5 stages ...
;

-- HARD QUERIES

SELECT `date`
FROM layoffs_staging2
;

-- rolling total of layoffs per month-year
SELECT SUBSTRING(`date`, 1, 7) AS `YEAR-MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
-- WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL OR SUBSTRING(`date`, 1, 7) = ' '
GROUP BY `YEAR-MONTH`
ORDER BY 1 DESC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `YEAR-MONTH`, SUM(total_laid_off) AS Total_layoffs
FROM layoffs_staging2
-- WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL OR SUBSTRING(`date`, 1, 7) = ' '
GROUP BY `YEAR-MONTH`
ORDER BY 1 DESC
)
SELECT `YEAR-MONTH`, Total_layoffs,
SUM(Total_layoffs) OVER (ORDER BY `YEAR-MONTH`) AS rolling_total
FROM Rolling_Total;


-- RANKING number of employee laid off each years of top 5 companies 
WITH Company_Year AS
(
	SELECT company, YEAR(`date`) AS years, SUM(total_laid_off) AS total_laid_offs
	FROM layoffs_staging2
-- 	WHERE years IS NOT NULL
	GROUP BY company, years
),
Company_Year_Rank AS 
(
	SELECT *, 
	DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_offs DESC) AS Ranking
	FROM Company_Year
--     WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;





