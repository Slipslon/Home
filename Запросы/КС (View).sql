ALTER VIEW TNKFU_KS AS -- для изменений


WITH AmountCTE as /*

			Блок Основной информации (

*/ (
	SELECT 
	s.IDSmetPos AS [ID] -- ID сметной позиции, для сортировки
	,s.NameSmetPos AS [Смет.п.] -- Сметная позиция
	,w.NameWork AS [Наименование работ]
	,w.Unit AS [Ед.изм.]
	,ads.Amount AS [Кол-во смета]
	,ads.Material_price AS [Цена мат.]
	,ads.Work_price AS [Цена раб.]
	,ISNULL(ads.Material_price,0)+ISNULL(ads.Work_price,0) AS [Ед цена]
	,n.Накопительная AS [Накопительная]
	,ISNULL(ads.Amount,0)-ISNULL(n.Накопительная,0) AS [Остаток]
	,s.IDInd1 AS [Индикатор 1]
	,s.IDInd2 AS [Индикатор 2]
	,s.IDInd3 AS [Индикатор 3]

	FROM Smeta s
	
	JOIN Works w ON s.IDWorks=w.ID



	LEFT JOIN (/*
	
					Объем относительно какого-то конкретного ДC
					SUM для нескольких ДС

			*/
				SELECT
				IDSmetPos,
				SUM (Amount) AS Amount,
				AVG (Material_price) AS Material_price,
				AVG (Work_price) AS Work_price
				FROM Amount_DS
				WHERE ID_DS IN (1)
				GROUP BY IDSmetPos
				) ads ON s.IDSmetPos=ads.IDSmetPos
				
			LEFT JOIN (/*
	
					Накопительная по всему объему КС. Суммируются только объемы, то есть не привязано к ДС
	
			*/
				SELECT
				IDSmetPos,
				SUM(Amount) [Накопительная]
				FROM Amount_KS
				GROUP BY IDSmetPos
				) n
				ON s.IDSmetPos=n.IDSmetPos
				
			/*
	
					Значения из РД по файлам
	
			*/
	),KSCTE AS ( -- 
	SELECT 
	IDSmetPos
	,[1] as [КС-1] 
	--- ,[2] as [КС-2]  и т.д.
	FROM Amount_KS

	PIVOT (SUM(Amount)  -- Pivot, для разворота всех объемов из таблицы по КСкам (в столбцы)
	FOR ID_KS IN ([1]/*,[2] и т.д.*/)) AS PivotTable
	)


SELECT 
ROW_NUMBER() OVER(ORDER BY Acte.ID ASC) AS R#   -- Номера строк, для сортировки в Power BI, так как там не поддерживается сортировка по hierarchyid
,Acte.ID.ToString() AS ID
,Acte.[Смет.п.]
,Acte.[Наименование работ]
,Acte.[Накопительная]
,kscte.[КС-1]
-- ,kscte.[КС-2] и т.д.
,Acte.[Индикатор 1]
,Acte.[Индикатор 2]
,Acte.[Индикатор 3]

FROM AmountCTE Acte
LEFT JOIN KSCTE kscte ON Acte.ID=kscte.IDSmetPos
