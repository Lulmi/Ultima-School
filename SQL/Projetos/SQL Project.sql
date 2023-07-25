/* Projeto de SQL: */
	
-- Questão Sugerida 1.a View
SELECT * FROM all_csv_limited10_cd

-- Questão Sugerida 1.b View
SELECT * FROM all_csv_limited10_cv

-- Questão Sugerida 2 View
SELECT * FROM total_cases_vs_total_deaths

-- Questão Sugerida 3 View
SELECT * FROM probability_of_covid_death

-- Questão Sugerida 4 View
SELECT * FROM total_cases_vs_population

-- Questão Sugerida 5 View
SELECT * FROM probability_of_infection_per_country

-- Questão Sugerida 6 View
SELECT * FROM top_5_probability_of_infection

-- Questão Sugerida 7 View
SELECT * FROM top_5_death_per_country

-- Questão Sugerida 8 View
SELECT * FROM ranking_continents_w_more_deaths

-- Questão Sugerida 9.a View
SELECT * FROM percent_population_vacinated_once_or_more

-- Questão Sugerida 9.b.I View
SELECT * FROM percent_population_vacinated_once_or_more_by_country

-- Questão Sugerida 9.b.II View
SELECT * FROM percent_population_vacinated_once_or_more_by_country_and_date

/* Questão sugerida 1.
 * Coloque os dados no Dbeaver - todos os csvs devem pertencer a 1 único database
 */ 

CREATE VIEW all_csv_limited10_cd AS
SELECT *
FROM CovidDeaths cd 
LIMIT 10

SELECT * FROM all_csv_limited10_cd

CREATE VIEW all_csv_limited10_cv AS
SELECT *
FROM CovidVaccinations cv
LIMIT 10

SELECT * FROM all_csv_limited10_cv

--DONE

/* Questão sugerida 2.
 * Faça uma tabela com uma coluna de total de casos e outra com total de mortes por país
 */

CREATE VIEW total_cases_vs_total_deaths AS
SELECT 
	location,
	SUM(new_cases) AS TotalCases,
	SUM(new_deaths) AS TotalDeaths
FROM CovidDeaths cd
WHERE continent LIKE "% %"
AND location IS NOT NULL
AND location <> "World"
GROUP BY location

SELECT * FROM total_cases_vs_total_deaths

--DONE

/* Questão sugerida 3.
 * Mostre a probabilidade de morrer se contrair covid em cada país
 */

CREATE VIEW probability_of_covid_death AS
SELECT
	location,
	SUM(new_deaths) / SUM(new_cases) AS prob_death_from_covid,
	CAST (ROUND(SUM(new_deaths) / SUM(new_cases), 3) AS VARCHAR) || "%" AS  prob_death_from_covid_perc
FROM CovidDeaths cd
WHERE continent LIKE "% %"
AND location IS NOT NULL
AND location <> "World"
GROUP BY location

SELECT * FROM probability_of_covid_death

--DONE

/* Questão sugerida 4.
 * Faça uma tabela com uma coluna de total de casos e outra com total população por país
 */

CREATE VIEW total_cases_vs_population AS
SELECT
	location,
	SUM(new_cases) AS TotalCases,
	population
FROM CovidDeaths cd
WHERE continent LIKE "% %"
AND location IS NOT NULL
AND location <> "World"
GROUP BY location

SELECT * FROM total_cases_vs_population

--DONE

/* Questão sugerida 5.
 * Mostre a probabilidade de se infectar com Covid por país
 */

CREATE VIEW probability_of_infection_per_country AS
SELECT
	location,
	population,
	SUM(CAST(new_cases AS INT)),
	ROUND(SUM(CAST(new_cases AS INT)) / CAST(population AS FLOAT) * 100, 3) || "%" AS prob_infec_from_covid
FROM CovidDeaths cd
WHERE continent LIKE"% %"
AND location IS NOT NULL
AND location <> "World"
GROUP BY location 

SELECT * FROM probability_of_infection_per_country

--DONE

/* Questão sugerida 6.
 * Quais são os países com maior taxa de infecção?
 */
DROP VIEW IF EXISTS top_5_probability_of_infection

CREATE VIEW top_5_probability_of_infection AS
SELECT
	location,
	population,
	SUM(CAST(new_cases AS INT)) AS total_new_cases,
	ROUND(SUM(CAST(new_cases AS INT)) / CAST(population AS FLOAT) * 100, 3) || "%" AS infected_perc
FROM CovidDeaths cd
WHERE continent LIKE"% %"
AND location IS NOT NULL
AND location <> "World"
GROUP BY location
ORDER BY infected_perc DESC
LIMIT 5

SELECT * FROM top_5_probability_of_infection

--DONE

/* Questão sugerida 7.
 * Quais são os países com maior taxa de morte?
 */

CREATE VIEW top_5_death_per_country AS
SELECT
	location,
	CAST (ROUND(SUM(new_deaths) / SUM(new_cases), 3) AS VARCHAR ) || "%" AS prob_death_from_covid
FROM CovidDeaths cd
WHERE continent LIKE "% %"
GROUP BY location
ORDER BY prob_death_from_covid DESC 
LIMIT 5

SELECT * FROM top_5_death_per_country

--DONE

/* Questão sugerida 8.
 * Mostre os continentes com a maior taxa de morte
 */

CREATE VIEW ranking_continents_w_more_deaths AS
SELECT
	continent,
	CAST (ROUND(SUM(new_deaths) / SUM(new_cases), 5) AS VARCHAR ) || "%" AS prob_death_from_covid
FROM CovidDeaths cd
WHERE continent IS NOT NULL
AND continent <> ""
AND location IS NOT NULL
AND location <> "World"
GROUP BY continent 
ORDER BY prob_death_from_covid DESC 

SELECT * FROM ranking_continents_w_more_deaths

--DONE

/* Questão sugerida 9.
 * População Total vs Vacinações:
 * 		a. mostre a porcentagem da população que recebeu pelo menos uma vacina contra a Covid.
 * 		b. Importante mostrar acumulado de vacina por data e localização.
 */

--item a.
CREATE VIEW percent_population_vacinated_once_or_more AS
SELECT
	cd.location,
	cd.population,
	MAX(CAST(cv.people_vaccinated AS INT)) AS ppl_vac,
	ROUND(MAX(CAST(cv.people_vaccinated AS INT)) / CAST(cd.population AS FLOAT) * 100, 3) || "%" AS perc_vac
FROM CovidDeaths cd 
LEFT JOIN CovidVaccinations cv ON cd.iso_code = cv.iso_code

SELECT * FROM percent_population_vacinated_once_or_more

--DONE

--item b.I (Localização)

CREATE VIEW percent_population_vacinated_once_or_more_by_country AS
SELECT
	cd.location,
	cd.population,
	MAX(CAST(cv.people_vaccinated AS INT)) AS ppl_vac,
	ROUND(MAX(CAST(cv.people_vaccinated AS INT)) / CAST(cd.population AS FLOAT) * 100, 3) || '%' AS perc_vac
FROM CovidDeaths cd
LEFT JOIN CovidVaccinations cv ON cd.iso_code = cv.iso_code
WHERE cd.continent IS NOT NULL
	AND cd.location IS NOT NULL
	AND cd.location <> 'World'
	AND cd.location <> 'Asia'
	AND cd.location <> 'North America'
	AND cd.location <> 'Europe'
	AND cd.location <> 'South America'
	AND cd.location <> 'Oceania'
	AND cd.location <> 'Africa'
	AND cd.location <> 'European Union'
GROUP BY cd.location
ORDER BY ppl_vac DESC

SELECT * FROM percent_population_vacinated_once_or_more_by_country

--DONE

--item b.II (Data)
CREATE VIEW percent_population_vacinated_once_or_more_by_country_and_date AS
SELECT
    cv.location,
    cv.date,
    SUM(CAST(cv.people_vaccinated AS INT)) OVER (PARTITION BY cv.location ORDER BY cv.date) AS accumulated_vaccinations
FROM CovidVaccinations cv
INNER JOIN CovidDeaths cd ON cv.iso_code = cd.iso_code
WHERE cv.people_vaccinated IS NOT NULL
GROUP BY cv.location, cv.date
ORDER BY cv.location, cv.date

SELECT * FROM percent_population_vacinated_once_or_more_by_country_and_date

--DONE

/* Questão sugerida 10.
 * Crie uma view para armazenar dados para visualizações posteriores
 */

--Foi adicionado a função CREATE VIEW para cada um dos itens, segue abaixo os acessos de cada questão

-- Questão Sugerida 1.a View
SELECT * FROM all_csv_limited10_cd

-- Questão Sugerida 1.b View
SELECT * FROM all_csv_limited10_cv

-- Questão Sugerida 2 View
SELECT * FROM total_cases_vs_total_deaths

-- Questão Sugerida 3 View
SELECT * FROM probability_of_covid_death

-- Questão Sugerida 4 View
SELECT * FROM total_cases_vs_population

-- Questão Sugerida 5 View
SELECT * FROM probability_of_infection_per_country

-- Questão Sugerida 6 View
SELECT * FROM top_5_probability_of_infection

-- Questão Sugerida 7 View
SELECT * FROM top_5_death_per_country

-- Questão Sugerida 8 View
SELECT * FROM ranking_continents_w_more_deaths

-- Questão Sugerida 9.a View
SELECT * FROM percent_population_vacinated_once_or_more

-- Questão Sugerida 9.b.I View
SELECT * FROM percent_population_vacinated_once_or_more_by_country

-- Questão Sugerida 9.b.II View
SELECT * FROM percent_population_vacinated_once_or_more_by_country_and_date