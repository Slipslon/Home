
---- Îñíîâíîå ïðåäñòàâëåíèå äëÿ çàãðóçêè â PowerBI

---- USE TNKFU

---- ALTER VIEW TNKFU AS  -- äëÿ èçìåíåíèÿ

------------ Áëîê CTE çàïðîñîâ ----------------------

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
	,cor.[Ñóììà COR] AS [Ñóììà COR]
	,ISNULL(cor.[Ñóììà COR],0)+ISNULL(ads.Amount,0) AS [Êîë-âî ñ CORàìè]
	,idoc.[Èòîã ÈÄ] AS [Èòîã ÈÄ]
	,ISNULL(idoc.[Èòîã ÈÄ],0) - ISNULL(n.Íàêîïèòåëüíàÿ,0) AS [Ðàçíèöà]
	,s.IDInd1 AS [Èíäèêàòîð 1]
	,s.IDInd2 AS [Èíäèêàòîð 2]
	,s.IDInd3 AS [Èíäèêàòîð 3]
	,s.IDInd7 AS [Èíäèêàòîð 7]
	,MaE.Code AS [ID Ìàòåðèàëà]
	,s.MAF
	,m.Status AS [Ñòàòóñ MAF]
	,ar.Çàêóïêà
	,ar.Îòâåòñòâåííûé
	,ar.Çàÿâêè AS [Çàÿâêè]

	FROM Smeta s
	
	JOIN Works w ON s.IDWorks=w.ID
	LEFT JOIN MAF m ON s.MAF=m.Number
			
			LEFT JOIN (/*
	
					Îáúåì îòíîñèòåëüíî êàêîãî-òî êîíêðåòíîãî ÄC
					SUM äëÿ íåñêîëüêèõ ÄÑ (êîãäà ðàçäåëèëè íà ýòàïû)

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
	
					Íàêîïèòåëüíàÿ ïî âñåìó îáúåìó ÊÑ. Ñóììèðóþòñÿ òîëüêî îáúåìû, òî åñòü íå ïðèâÿçàíî ê ÄÑ
	
			*/
				SELECT
				IDSmetPos,
				SUM(Amount) [Íàêîïèòåëüíàÿ]
				FROM Amount_KS
				GROUP BY IDSmetPos
				) n
				ON s.IDSmetPos=n.IDSmetPos
			
			
			LEFT JOIN (/*
	
					Íàêîïèòåëüíàÿ ïî âñåìó îáúåìó COR
	
			*/
				SELECT
				IDSmetPos,
				SUM(Amount) [Ñóììà COR]
				FROM Amount_COR
				GROUP BY IDSmetPos
				) cor
				ON s.IDSmetPos=cor.IDSmetPos
			
			LEFT JOIN (/*
	
					Íàêîïèòåëüíàÿ ïî âñåìó îáúåìó ÈÄ. Ñóììèðóþòñÿ òîëüêî îáúåìû, òî åñòü íå ïðèâÿçàíî ê ÄÑ.
	
			*/
				SELECT
				IDSmetPos
				,SUM(Amount) AS [Èòîã ÈÄ]
				FROM Amount_IDoc
				WHERE [ID_IDoc] IN (1)
				GROUP BY IDSmetPos
				) idoc
				ON s.IDSmetPos=idoc.IDSmetPos
			
			
			LEFT JOIN 
			
			Materials_and_Equipments MaE ON w.[IDMandEq]=MaE.ID
			
			LEFT JOIN (/*
	
					Íàêîïèòåëüíàÿ ïî âñåìó îáúåìó Çàÿâîê. Ñóììèðóþòñÿ òîëüêî îáúåìû, òî åñòü íå ïðèâÿçàíî ê ÄÑ
	
			*/
				SELECT
				a_r.IDSmetPos
				,STRING_AGG(a_r.IDRequest,', ') [Çàÿâêè]
				,SUM(a_r.Amount) [Çàêóïêà]
				,STRING_AGG(r.Responsible,', ') WITHIN GROUP ( ORDER BY r.Responsible ASC) [Îòâåòñòâåííûé]
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
					[Èâàíîâ1],
					[Èâàíîâ2]
				FROM (
					SELECT 
						IDSmetPos,
						Responsible,
						Amount
					FROM Amount_Request
				) AS SourceTable
				PIVOT (
					SUM(Amount)  
					FOR Responsible IN ([Èâàíîâ1],[Èâàíîâ2])
				) AS PivotTable
	)
	
	


----------------------------Îñíîâíîé áëîê çàïðîñà ïî âûøåîïèñàííûì CTE
SELECT 
ROW_NUMBER() OVER(ORDER BY Acte.ID ASC) AS R#   -- Íîìåðà ñòðîê, äëÿ ñîðòèðîâêè â Power BI, òàê êàê òàì íå ïîääåðæèâàåòñÿ ñîðòèðîâêà ïî hierarchyid
,Acte.ID.ToString() AS ID
,Acte.[Ñìåò.ï.]
,Acte.[Íàèìåíîâàíèå ðàáîò]
,Acte.[Êîë-âî ñìåòà]
,Acte.[Öåíà ìàò.]
,Acte.[Öåíà ðàá.]
,Acte.[Åä öåíà]
,Acte.[Êîë-âî ñìåòà]*Acte.[Åä öåíà] AS [Ñòîèìîñòü ñìåòà]
,Acte.[Íàêîïèòåëüíàÿ]
,Acte.[Íàêîïèòåëüíàÿ]*Acte.[Åä öåíà] AS [Ñòîèìîñòü Íàê.]
,Acte.[Îñòàòîê]
,Acte.[Îñòàòîê]*Acte.[Åä öåíà] AS [Ñòîèìîñòü Îñò.]
,Acte.[Ñóììà COR]
,Acte.[Êîë-âî ñ CORàìè]
,Acte.[Êîë-âî ñ CORàìè]*Acte.[Åä öåíà] AS [Ñòîèìîñòü c CORàìè]
,Acte.[Èíäèêàòîð 1]
,Acte.[Èíäèêàòîð 2]
,Acte.[Èíäèêàòîð 3]
,Acte.[Èíäèêàòîð 7]
,Acte.MAF
,Acte.[Ñòàòóñ MAF]
,Acte.Çàêóïêà
,Acte.Îòâåòñòâåííûé
,Acte.Çàÿâêè
,Reqcte.[Èâàíîâ1]
,Reqcte.[Èâàíîâ2]


FROM AmountCTE Acte
LEFT JOIN RequestCTE Reqcte ON Acte.ID=Reqcte.[IDSmetPos]
