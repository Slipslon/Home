ALTER VIEW TNKFU_RD_ID AS -- äëÿ èçìåíåíèé


WITH AmountCTE as /*

			Áëîê Îñíîâíîé èíôîðìàöèè (

*/ (
	SELECT 
	s.IDSmetPos AS [ID] -- ID ñìåòíîé ïîçèöèè, äëÿ ñîðòèðîâêè
	,s.NameSmetPos AS [Ñìåò.ï.] -- Ñìåòíàÿ ïîçèöèÿ
	,w.NameWork AS [Íàèìåíîâàíèå ðàáîò]
	,w.Unit AS [Åä.èçì.]
	,rds.[Èòîã ÐÄ]
	,ids.[Èòîã ÈÄ]
	,s.IDInd1 AS [Èíäèêàòîð 1]
	,s.IDInd2 AS [Èíäèêàòîð 2]
	,s.IDInd3 AS [Èíäèêàòîð 3]

	FROM Smeta s
	
	JOIN Works w ON s.IDWorks=w.ID



	LEFT JOIN (/*
	
					Çíà÷åíèÿ èç ÐÄ 
	
			*/
				SELECT
				IDSmetPos
				,SUM(Amount) AS [Èòîã ÐÄ]
				FROM Amount_RDoc
				GROUP BY IDSmetPos
				) rds
	ON s.IDSmetPos=rds.IDSmetPos
				

	LEFT JOIN (/*
	
					Çíà÷åíèÿ èç ÈÄ 
	
			*/
				SELECT
				IDSmetPos
				,SUM(Amount) AS [Èòîã ÈÄ]
				FROM Amount_IDoc
				GROUP BY IDSmetPos
				) ids
	ON s.IDSmetPos=ids.IDSmetPos
				
			/*
	
					Çíà÷åíèÿ èç ÐÄ ïî ôàéëàì
	
			*/
	),RDocCTE as (
				SELECT 
				IDSmetPos

				-- ïåðå÷èñëåíèå âñåõ ôàéëîâ ïî ïðèìåðó ,[2] AS [ÀÂÊ ¹1/ÌÁ/ÀÑÓÄ]
				,[1] AS [8.ÀÑÄÓ.DALI.Ñïåöèôèêàöèÿ]

				FROM (
				SELECT 
				IDSmetPos,
				SUM(Amount) AS Amount,
				ID_RDoc
				FROM Amount_RDoc
				group by IDSmetPos, ID_RDoc
				) AS Amount_RDoc
				
				PIVOT (SUM(Amount_RDoc.Amount)
				FOR ID_RDoc IN ([1])-- íèæå ID äîêóìåíòîâ â ñêîáêàõ
				) AS PivotTable1
				
	)
	/*
	
					Çíà÷åíèÿ èç ÈÄ ïî ôàéëàì
	
			*/
	,IDocCTE as (
				SELECT 
				IDSmetPos

				-- ïåðå÷èñëåíèå âñåõ ôàéëîâ ïî ïðèìåðó ,[2] AS [ÀÂÊ ¹1/ÌÁ/ÀÑÓÄ]
				,[1] AS [Âåä.8.ÀÑÄÓ.DALI]

				FROM (
				SELECT 
				IDSmetPos,
				SUM(Amount) AS Amount,
				ID_IDoc
				FROM Amount_IDoc
				group by IDSmetPos, ID_IDoc
				) AS Amount_IDoc
				PIVOT (SUM(Amount_IDoc.Amount)
				FOR ID_IDoc IN -- íèæå ID äîêóìåíòîâ â ñêîáêàõ
				([1]))
				AS PivotTable2
				
	)


SELECT 
ROW_NUMBER() OVER(ORDER BY Acte.ID ASC) AS R#   -- Íîìåðà ñòðîê, äëÿ ñîðòèðîâêè â Power BI, òàê êàê òàì íå ïîääåðæèâàåòñÿ ñîðòèðîâêà ïî hierarchyid
,Acte.ID.ToString() AS ID
,Acte.[Ñìåò.ï.]
,Acte.[Íàèìåíîâàíèå ðàáîò]
,Acte.[Èòîã ÐÄ]
,Rdocte.[8.ÀÑÄÓ.DALI.Ñïåöèôèêàöèÿ] -- è äðóãèå ôàéëû èç RDocCTE
,Acte.[Èòîã ÈÄ]
,Idocte.[Âåä.8.ÀÑÄÓ.DALI] -- è äðóãèå ôàéëû èç IDocCTE
,Acte.[Èíäèêàòîð 1]
,Acte.[Èíäèêàòîð 2]
,Acte.[Èíäèêàòîð 3]

FROM AmountCTE Acte
LEFT JOIN RDocCTE Rdocte ON Acte.ID=Rdocte.IDSmetPos
LEFT JOIN IDocCTE Idocte ON Acte.ID=Rdocte.IDSmetPos
