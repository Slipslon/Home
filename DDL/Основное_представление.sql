
---- Основное представление для загрузки в PowerBI

---- USE TNKFU

---- ALTER VIEW TNKFU AS  -- для изменения

------------ Блок CTE запросов ----------------------

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
	,cor.[Сумма COR] AS [Сумма COR]
	,ISNULL(cor.[Сумма COR],0)+ISNULL(ads.Amount,0) AS [Кол-во с CORами]
	,idoc.[Итог ИД] AS [Итог ИД]
	,ISNULL(idoc.[Итог ИД],0) - ISNULL(n.Накопительная,0) AS [Разница]
	,s.IDInd1 AS [Индикатор 1]
	,s.IDInd2 AS [Индикатор 2]
	,s.IDInd3 AS [Индикатор 3]
	,s.IDInd7 AS [Индикатор 7]
	,MaE.Code AS [ID Материала]
	,s.MAF
	,m.Status AS [Статус MAF]
	,ar.Закупка
	,ar.Ответственный
	,ar.Заявки AS [Заявки]

	FROM Smeta s
	
	JOIN Works w ON s.IDWorks=w.ID
	LEFT JOIN MAF m ON s.MAF=m.Number
			
			LEFT JOIN (/*
	
					Объем относительно какого-то конкретного ДC
					SUM для нескольких ДС (когда разделили на этапы)

			*/
				SELECT
				IDSmetPos,
				SUM (Amount) AS Amount,
				AVG (Material_price) AS Material_price,
				AVG (Work_price) AS Work_price
				FROM Amount_DS
				WHERE ID_DS IN (1,2,3,4)
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
			
			
			LEFT JOIN (/*
	
					Накопительная по всему объему COR
	
			*/
				SELECT
				IDSmetPos,
				SUM(Amount) [Сумма COR]
				FROM Amount_COR
				GROUP BY IDSmetPos
				) cor
				ON s.IDSmetPos=cor.IDSmetPos
			
			LEFT JOIN (/*
	
					Накопительная по всему объему ИД. Суммируются только объемы, то есть не привязано к ДС.
	
			*/
				SELECT
				IDSmetPos
				,SUM(Amount) AS [Итог ИД]
				FROM Amount_IDoc
				WHERE [ID_IDoc] IN (1)
				GROUP BY IDSmetPos
				) idoc
				ON s.IDSmetPos=idoc.IDSmetPos
			
			
			LEFT JOIN 
			
			Materials_and_Equipments MaE ON w.[IDMandEq]=MaE.ID
			
			LEFT JOIN (/*
	
					Накопительная по всему объему Заявок. Суммируются только объемы, то есть не привязано к ДС
	
			*/
				SELECT
				a_r.IDSmetPos
				,STRING_AGG(a_r.IDRequest,', ') [Заявки]
				,SUM(a_r.Amount) [Закупка]
				,STRING_AGG(r.Responsible,', ') WITHIN GROUP ( ORDER BY r.Responsible ASC) [Ответственный]
				FROM Amount_Request a_r
				
				LEFT JOIN (
						SELECT
						IDRequest
						,Responsible
						From Request
						) r on a_r.IDRequest=r.IDRequest
						
				GROUP BY IDSmetPos
				
				) ar
				ON s.IDSmetPos=ar.IDSmetPos

			
			)

	,RequestCTE AS ( -- 
				SELECT 
					IDSmetPos,
					[Иванов1],
					[Иванов2]
				FROM (
					SELECT 
						IDSmetPos,
						Responsible,
						Amount
					FROM Amount_Request
				) AS SourceTable
				PIVOT (
					SUM(Amount)  
					FOR Responsible IN ([Иванов1],[Иванов2])
				) AS PivotTable
	)
	
	


----------------------------Основной блок запроса по вышеописанным CTE
SELECT 
ROW_NUMBER() OVER(ORDER BY Acte.ID ASC) AS R#   -- Номера строк, для сортировки в Power BI, так как там не поддерживается сортировка по hierarchyid
,Acte.ID.ToString() AS ID
,Acte.[Смет.п.]
,Acte.[Наименование работ]
,Acte.[Кол-во смета]
,Acte.[Цена мат.]
,Acte.[Цена раб.]
,Acte.[Ед цена]
,Acte.[Кол-во смета]*Acte.[Ед цена] AS [Стоимость смета]
,Acte.[Накопительная]
,Acte.[Накопительная]*Acte.[Ед цена] AS [Стоимость Нак.]
,Acte.[Остаток]
,Acte.[Остаток]*Acte.[Ед цена] AS [Стоимость Ост.]
,Acte.[Сумма COR]
,Acte.[Кол-во с CORами]
,Acte.[Кол-во с CORами]*Acte.[Ед цена] AS [Стоимость c CORами]
,Acte.[Индикатор 1]
,Acte.[Индикатор 2]
,Acte.[Индикатор 3]
,Acte.[Индикатор 7]
,Acte.MAF
,Acte.[Статус MAF]
,Acte.Закупка
,Acte.Ответственный
,Acte.Заявки
,Reqcte.[Иванов1]
,Reqcte.[Иванов2]


FROM AmountCTE Acte
LEFT JOIN RequestCTE Reqcte ON Acte.ID=Reqcte.[IDSmetPos]
