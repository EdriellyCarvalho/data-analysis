
-- Comparativo de faturamento das lojas entre 2008 e 2009
-- Base de Dados: ContosoRetailDW

USE ContosoRetailDW

SELECT TOP 10
	ST.StoreName AS 'Loja' 
	,G.CityName AS 'Cidade'
	,G.RegionCountryName AS 'Pais/Regiao'
	,ROUND(SUM(CASE WHEN D.CalendarYear = 2008 THEN S.SalesAmount ELSE 0 END), 2) AS Faturamento_2008, 
	ROUND(SUM(CASE WHEN D.CalendarYear = 2009 THEN S.SalesAmount ELSE 0 END), 2) AS Faturamento_2009
FROM FactSales AS S

-- Juntando as tabelas
JOIN DimStore AS ST 
	 ON S.StoreKey = ST.StoreKey
JOIN DimGeography AS G 
	 ON G.GeographyKey = ST.GeographyKey
JOIN DimDate AS D
	 ON	S.DateKey = D.Datekey
GROUP BY ST.StoreName, G.CityName, G.RegionCountryName
ORDER BY Faturamento_2009 DESC;