ALTER VIEW TNKFU_RD_ID AS -- для изменений


WITH AmountCTE as /*

			Блок Основной информации (

*/ (
	SELECT 
	s.IDSmetPos AS [ID] -- ID сметной позиции, для сортировки
	,s.NameSmetPos AS [Смет.п.] -- Сметная позиция
	,w.NameWork AS [Наименование работ]
	,w.Unit AS [Ед.изм.]
	,rds.[Итог РД]
	,ids.[Итог ИД]
	,s.IDInd1 AS [Индикатор 1]
	,s.IDInd2 AS [Индикатор 2]
	,s.IDInd3 AS [Индикатор 3]

	FROM Smeta s
	
	JOIN Works w ON s.IDWorks=w.ID



	LEFT JOIN (/*
	
					Значения из РД 
	
			*/
				SELECT
				IDSmetPos
				,SUM(Amount) AS [Итог РД]
				FROM Amount_RDoc
				GROUP BY IDSmetPos
				) rds
	ON s.IDSmetPos=rds.IDSmetPos
				

	LEFT JOIN (/*
	
					Значения из ИД 
	
			*/
				SELECT
				IDSmetPos
				,SUM(Amount) AS [Итог ИД]
				FROM Amount_IDoc
				GROUP BY IDSmetPos
				) ids
	ON s.IDSmetPos=ids.IDSmetPos
				
			/*
	
					Значения из РД по файлам
	
			*/
	),RDocCTE as (
				SELECT 
				IDSmetPos

				-- перечисление всех файлов по примеру ,[2] AS [АВК №1/МБ/АСУД]
				,[1] AS [8.АСДУ.DALI.Спецификация]

				FROM (
				SELECT 
				IDSmetPos,
				SUM(Amount) AS Amount,
				ID_RDoc
				FROM Amount_RDoc
				group by IDSmetPos, ID_RDoc
				) AS Amount_RDoc
				
				PIVOT (SUM(Amount_RDoc.Amount)
				FOR ID_RDoc IN ([1])-- ниже ID документов в скобках
				) AS PivotTable1
				
	)
	/*
	
					Значения из ИД по файлам
	
			*/
	,IDocCTE as (
				SELECT 
				IDSmetPos

				-- перечисление всех файлов по примеру ,[2] AS [АВК №1/МБ/АСУД]
				,[1] AS [Вед.8.АСДУ.DALI]

				FROM (
				SELECT 
				IDSmetPos,
				SUM(Amount) AS Amount,
				ID_IDoc
				FROM Amount_IDoc
				group by IDSmetPos, ID_IDoc
				) AS Amount_IDoc
				PIVOT (SUM(Amount_IDoc.Amount)
				FOR ID_IDoc IN -- ниже ID документов в скобках
				([1]))
				AS PivotTable2
				
	)


SELECT 
ROW_NUMBER() OVER(ORDER BY Acte.ID ASC) AS R#   -- Номера строк, для сортировки в Power BI, так как там не поддерживается сортировка по hierarchyid
,Acte.ID.ToString() AS ID
,Acte.[Смет.п.]
,Acte.[Наименование работ]
,Acte.[Итог РД]
,Rdocte.[8.АСДУ.DALI.Спецификация] -- и другие файлы из RDocCTE
,Acte.[Итог ИД]
,Idocte.[Вед.8.АСДУ.DALI] -- и другие файлы из IDocCTE
,Acte.[Индикатор 1]
,Acte.[Индикатор 2]
,Acte.[Индикатор 3]

FROM AmountCTE Acte
LEFT JOIN RDocCTE Rdocte ON Acte.ID=Rdocte.IDSmetPos
LEFT JOIN IDocCTE Idocte ON Acte.ID=Rdocte.IDSmetPos
