ALTER VIEW TNKFU_KS AS -- äëÿ èçìåíåíèé


WITH AmountCTE as /*

			Áëîê Îñíîâíîé èíôîðìàöèè (

*/ (
	SELECT 
	s.IDSmetPos AS [ID] -- ID ñìåòíîé ïîçèöèè, äëÿ ñîðòèðîâêè
	,s.NameSmetPos AS [Ñìåò.ï.] -- Ñìåòíàÿ ïîçèöèÿ
	,w.NameWork AS [Íàèìåíîâàíèå ðàáîò]
	,w.Unit AS [Åä.èçì.]
	,ads.Amount AS [Êîë-âî ñìåòà]
	,ads.Material_price AS [Öåíà ìàò.]
	,ads.Work_price AS [Öåíà ðàá.]
	,ISNULL(ads.Material_price,0)+ISNULL(ads.Work_price,0) AS [Åä öåíà]
	,n.Íàêîïèòåëüíàÿ AS [Íàêîïèòåëüíàÿ]
	,ISNULL(ads.Amount,0)-ISNULL(n.Íàêîïèòåëüíàÿ,0) AS [Îñòàòîê]
	,s.IDInd1 AS [Èíäèêàòîð 1]
	,s.IDInd2 AS [Èíäèêàòîð 2]
	,s.IDInd3 AS [Èíäèêàòîð 3]

	FROM Smeta s
	
	JOIN Works w ON s.IDWorks=w.ID



	LEFT JOIN (/*
	
					Îáúåì îòíîñèòåëüíî êàêîãî-òî êîíêðåòíîãî ÄC
					SUM äëÿ íåñêîëüêèõ ÄÑ

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
	
					Íàêîïèòåëüíàÿ ïî âñåìó îáúåìó ÊÑ. Ñóììèðóþòñÿ òîëüêî îáúåìû, òî åñòü íå ïðèâÿçàíî ê ÄÑ
	
			*/
				SELECT
				IDSmetPos,
				SUM(Amount) [Íàêîïèòåëüíàÿ]
				FROM Amount_KS
				GROUP BY IDSmetPos
				) n
				ON s.IDSmetPos=n.IDSmetPos
				
			/*
	
					Çíà÷åíèÿ èç ÐÄ ïî ôàéëàì
	
			*/
	),KSCTE AS ( -- 
	SELECT 
	IDSmetPos
	,[1] as [ÊÑ-1] 
	--- ,[2] as [ÊÑ-2]  è ò.ä.
	FROM Amount_KS

	PIVOT (SUM(Amount)  -- Pivot, äëÿ ðàçâîðîòà âñåõ îáúåìîâ èç òàáëèöû ïî ÊÑêàì (â ñòîëáöû)
	FOR ID_KS IN ([1]/*,[2] è ò.ä.*/)) AS PivotTable
	)


SELECT 
ROW_NUMBER() OVER(ORDER BY Acte.ID ASC) AS R#   -- Íîìåðà ñòðîê, äëÿ ñîðòèðîâêè â Power BI, òàê êàê òàì íå ïîääåðæèâàåòñÿ ñîðòèðîâêà ïî hierarchyid
,Acte.ID.ToString() AS ID
,Acte.[Ñìåò.ï.]
,Acte.[Íàèìåíîâàíèå ðàáîò]
,Acte.[Íàêîïèòåëüíàÿ]
,kscte.[ÊÑ-1]
-- ,kscte.[ÊÑ-2] è ò.ä.
,Acte.[Èíäèêàòîð 1]
,Acte.[Èíäèêàòîð 2]
,Acte.[Èíäèêàòîð 3]

FROM AmountCTE Acte
LEFT JOIN KSCTE kscte ON Acte.ID=kscte.IDSmetPos
