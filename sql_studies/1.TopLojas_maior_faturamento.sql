/*
PROJETO 1: Top 10 Lojas com Maior Faturamento em 2009
Base de dados: ContosoRetailDW
Objetivo: Identificar as lojas com maior valor de vendas, por ano e pa�s.
Autor: Edrielly Carvalho
*/

--Definindo o banco de dados que ser� usado
USE ContosoRetailDW

--Selecionando as 10 lojas com maior faturamento
SELECT TOP 10
	ROUND(SUM(S.SalesAmount), 2) AS 'Faturamento' --Soma o valor das vendas e arredonda para 2 casas decimais
	,D.CalendarYear AS 'Ano' 
	,ST.StoreName AS 'Loja' 
	,G.CityName AS 'Cidade' 
	,G.RegionCountryName AS 'Pa�s/Regi�o' 
FROM FactSales AS S

-- Juntando as tabelas
JOIN DimStore AS ST 
	 ON S.StoreKey = ST.StoreKey
JOIN DimGeography AS G 
	 ON G.GeographyKey = ST.GeographyKey
JOIN DimDate AS D
	 ON	S.DateKey = D.Datekey
WHERE D.CalendarYear = 2009 -- filtro por ano
GROUP BY D.CalendarYear, ST.StoreName, G.CityName, G.RegionCountryName -- Agrupando os resultados 
ORDER BY Faturamento DESC; -- Ordena os resultados do maior para o menor faturamento