/*
PROJETO 2: Comportamento de vendas ao longo do tempo
Base de dados: AdventureWorksDW2022
O objetivo foi responder três perguntas principais:
1. Qual o total de vendas por mês e ano?
2. Há sazonalidade nas vendas (meses com picos)?
3. Como o número de transações varia com o tempo?
Para organizar as etapas da análise, usei CTEs (Common Table Expressions), 
uma ótima forma de deixar o código mais limpo e facilitar o encadeamento das consultas. 
Autor: Edrielly Carvalho
*/

--1. Somar o faturamento mensal e anual, e filtrar o mês/ano com maior e menor faturamento;

USE AdventureWorksDW2022;

WITH VendasMensais AS
(
	SELECT 
		ROUND(SUM(i.SalesAmount), 2) AS Faturamento
		,d.CalendarYear AS Ano
		,d.MonthNumberOfYear AS Mês
	FROM FactInternetSales AS i
	JOIN DimDate AS d
		ON i.ShipDateKey = d.DateKey
	GROUP BY d.CalendarYear, d.MonthNumberOfYear
)

SELECT *
FROM VendasMensais
WHERE Faturamento = (SELECT MAX(Faturamento) FROM VendasMensais)
	OR Faturamento = (SELECT MIN(Faturamento) FROM VendasMensais)
ORDER BY Ano, Mês


-- 2. Calcular a média de vendas por mês e comparar os resultados entre meses usando a função LAG(), observando variações percentuais;

USE AdventureWorksDW2022;

WITH VendasMensais AS
(
	SELECT 
		ROUND(SUM(i.SalesAmount), 2) AS Faturamento
		,d.CalendarYear AS Ano
		,d.MonthNumberOfYear AS Mês
	FROM FactInternetSales AS i
	JOIN DimDate AS d
		ON i.ShipDateKey = d.DateKey
	GROUP BY d.CalendarYear, d.MonthNumberOfYear
)

SELECT 
	Mês
	,AVG(Faturamento) AS 'Media_Mensal'
	,FORMAT(LAG(AVG(Faturamento), 1, 0) OVER(ORDER BY Mês ASC), 'C0') AS Media_Mês_Anterior
	,ROUND(
        ((AVG(Faturamento) - LAG(AVG(Faturamento)) OVER (ORDER BY Mês))
         / LAG(AVG(Faturamento)) OVER (ORDER BY Mês)) * 100, 
    2) AS Variacao_Perc
FROM VendasMensais
GROUP BY Mês
ORDER BY Mês

-- 3. E identificar quais meses e anos tiveram o maior e o menor número de vendas.

Use AdventureWorksDW2022;

WITH Numero_Transacoes AS
(
	SELECT 
			COUNT(SalesOrderNumber) AS Numero_Vendas
			,d.CalendarYear AS Ano
			,d.MonthNumberOfYear AS Mês
		FROM FactInternetSales AS i
		JOIN DimDate AS d
			ON i.ShipDateKey = d.DateKey
		GROUP BY d.CalendarYear, d.MonthNumberOfYear
)
SELECT *
FROM (
	SELECT
		Ano
		,Mês
		,Numero_Vendas
		,MAX(Numero_Vendas) OVER (PARTITION BY ANO) AS Max_Ano
		,MIN(Numero_Vendas) OVER (PARTITION BY ANO) AS Min_Ano
	FROM Numero_Transacoes
) AS t
WHERE Numero_Vendas = Max_Ano
	OR Numero_Vendas = Min_Ano
ORDER BY Ano, Mês
	