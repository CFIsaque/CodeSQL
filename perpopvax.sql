SELECT *
FROM covid_deaths
WHERE continent IS NOT NULL


SELECT *
FROM covid_vaccinations


-- SELECIONAR OS DADOS A SEREM TRABALHADOS

SELECT location, date, total_cases,	new_cases, total_deaths, population
FROM covid_deaths
WHERE continent IS NOT NULL
ORDER BY 1,2

-- BUSCAR TOTAL DE CASOS X TOTAL DE MORTOS (PORCENTAGEM DE MORTOS POR CASOS DE COVID)

SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS perdeath
FROM covid_deaths
WHERE location LIKE 'Brazil'
AND continent IS NOT NULL

-- BUSCAR O TOTAL DE CASOS X POPULAÇÃO (PORCENTAGEM DA POPULAÇÃO QUE CONTRAIU COVID)

SELECT location, date, population, total_cases, (total_cases/population)*100 AS infect
FROM covid_deaths
WHERE location LIKE 'Brazil'
WHERE continent IS NOT NULL

-- QUAIS OS PAÍSES COM MAIOR TAXA DE INFECTADOS EM COMPARAÇÃO COM A POPULAÇÃO?

SELECT location, population, MAX(total_cases) as TotalInfct, MAX(total_cases/population)*100 perinfect
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY perinfect DESC

-- TOTAL DE MORTOS X POPULAÇÃO (PORCENTAGEM DA POPULAÇÃO QUE FALECEU DE COVID)

SELECT location, MAX(cast(total_deaths as int)) AS totalmortes, MAX(total_deaths/population)*100 
AS permortes 
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY totalmortes DESC

-- DETALHAR POR CONTINENTE

SELECT continent, MAX(cast(total_deaths AS INT)) AS totalmortes
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY totalmortes DESC

-- NÚMEROS GLOBAIS

SELECT date, SUM(new_cases) AS totalcasos, SUM(CAST(new_deaths AS int)) AS totalmortes
, SUM(CAST(total_deaths AS int))/SUM(CAST(total_cases AS int))*100 AS perdeath
FROM covid_deaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2

-- NOVAS VACINAÇÕES, TOTAL DE PESSOAS VACINADAS E PORCENTAGEM DA POPULAÇÃO VACINADA
-- Usando CTE

WITH PopVax(Continent, Location, Date, Population, New_Vax, Soma_Vax)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint, vac.new_vaccinations)) OVER(PARTITION BY dea.location ORDER BY dea.location, dea.date) AS somavax
FROM covid_deaths AS dea
JOIN covid_vaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
AND dea.location LIKE 'Brazil'
)

SELECT *, (Soma_Vax/Population)*100 AS PerVax
FROM PopVax

-- CRIAR UMA VIEW PARA USAR EM VISUALIZAÇÕES

CREATE VIEW porcentagempopvax AS
SELECT dea.continent, dea.location, dea.date, dea.population, vax.new_vaccinations
, SUM(CONVERT(bigint, vax.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS somavax
FROM covid_deaths AS dea
JOIN covid_vaccinations AS vax
	ON dea.location = vax.location
	AND dea.date = vax.date
WHERE dea.continent IS NOT NULL

SELECT *
FROM porcentagempopvax
