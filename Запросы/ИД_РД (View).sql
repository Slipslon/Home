ALTER VIEW TNKFU_RD_ID AS -- ��� ���������


WITH AmountCTE as /*

			���� �������� ���������� (

*/ (
	SELECT 
	s.IDSmetPos AS [ID] -- ID ������� �������, ��� ����������
	,s.NameSmetPos AS [����.�.] -- ������� �������
	,w.NameWork AS [������������ �����]
	,w.Unit AS [��.���.]
	,rds.[���� ��]
	,ids.[���� ��]
	,s.IDInd1 AS [��������� 1]
	,s.IDInd2 AS [��������� 2]
	,s.IDInd3 AS [��������� 3]

	FROM Smeta s
	
	JOIN Works w ON s.IDWorks=w.ID



	LEFT JOIN (/*
	
					�������� �� �� 
	
			*/
				SELECT
				IDSmetPos
				,SUM(Amount) AS [���� ��]
				FROM Amount_RDoc
				GROUP BY IDSmetPos
				) rds
	ON s.IDSmetPos=rds.IDSmetPos
				

	LEFT JOIN (/*
	
					�������� �� �� 
	
			*/
				SELECT
				IDSmetPos
				,SUM(Amount) AS [���� ��]
				FROM Amount_IDoc
				GROUP BY IDSmetPos
				) ids
	ON s.IDSmetPos=ids.IDSmetPos
				
			/*
	
					�������� �� �� �� ������
	
			*/
	),RDocCTE as (
				SELECT 
				IDSmetPos

				-- ������������ ���� ������ �� ������� ,[2] AS [��� �1/��/����]
				,[1] AS [8.����.DALI.������������]

				FROM (
				SELECT 
				IDSmetPos,
				SUM(Amount) AS Amount,
				ID_RDoc
				FROM Amount_RDoc
				group by IDSmetPos, ID_RDoc
				) AS Amount_RDoc
				
				PIVOT (SUM(Amount_RDoc.Amount)
				FOR ID_RDoc IN ([1])-- ���� ID ���������� � �������
				) AS PivotTable1
				
	)
	/*
	
					�������� �� �� �� ������
	
			*/
	,IDocCTE as (
				SELECT 
				IDSmetPos

				-- ������������ ���� ������ �� ������� ,[2] AS [��� �1/��/����]
				,[1] AS [���.8.����.DALI]

				FROM (
				SELECT 
				IDSmetPos,
				SUM(Amount) AS Amount,
				ID_IDoc
				FROM Amount_IDoc
				group by IDSmetPos, ID_IDoc
				) AS Amount_IDoc
				PIVOT (SUM(Amount_IDoc.Amount)
				FOR ID_IDoc IN -- ���� ID ���������� � �������
				([1]))
				AS PivotTable2
				
	)


SELECT 
ROW_NUMBER() OVER(ORDER BY Acte.ID ASC) AS R#   -- ������ �����, ��� ���������� � Power BI, ��� ��� ��� �� �������������� ���������� �� hierarchyid
,Acte.ID.ToString() AS ID
,Acte.[����.�.]
,Acte.[������������ �����]
,Acte.[���� ��]
,Rdocte.[8.����.DALI.������������] -- � ������ ����� �� RDocCTE
,Acte.[���� ��]
,Idocte.[���.8.����.DALI] -- � ������ ����� �� IDocCTE
,Acte.[��������� 1]
,Acte.[��������� 2]
,Acte.[��������� 3]

FROM AmountCTE Acte
LEFT JOIN RDocCTE Rdocte ON Acte.ID=Rdocte.IDSmetPos
LEFT JOIN IDocCTE Idocte ON Acte.ID=Rdocte.IDSmetPos
