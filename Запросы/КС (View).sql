ALTER VIEW TNKFU_KS AS -- ��� ���������


WITH AmountCTE as /*

			���� �������� ���������� (

*/ (
	SELECT 
	s.IDSmetPos AS [ID] -- ID ������� �������, ��� ����������
	,s.NameSmetPos AS [����.�.] -- ������� �������
	,w.NameWork AS [������������ �����]
	,w.Unit AS [��.���.]
	,ads.Amount AS [���-�� �����]
	,ads.Material_price AS [���� ���.]
	,ads.Work_price AS [���� ���.]
	,ISNULL(ads.Material_price,0)+ISNULL(ads.Work_price,0) AS [�� ����]
	,n.������������� AS [�������������]
	,ISNULL(ads.Amount,0)-ISNULL(n.�������������,0) AS [�������]
	,s.IDInd1 AS [��������� 1]
	,s.IDInd2 AS [��������� 2]
	,s.IDInd3 AS [��������� 3]

	FROM Smeta s
	
	JOIN Works w ON s.IDWorks=w.ID



	LEFT JOIN (/*
	
					����� ������������ ������-�� ����������� �C
					SUM ��� ���������� ��

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
	
					������������� �� ����� ������ ��. ����������� ������ ������, �� ���� �� ��������� � ��
	
			*/
				SELECT
				IDSmetPos,
				SUM(Amount) [�������������]
				FROM Amount_KS
				GROUP BY IDSmetPos
				) n
				ON s.IDSmetPos=n.IDSmetPos
				
			/*
	
					�������� �� �� �� ������
	
			*/
	),KSCTE AS ( -- 
	SELECT 
	IDSmetPos
	,[1] as [��-1] 
	--- ,[2] as [��-2]  � �.�.
	FROM Amount_KS

	PIVOT (SUM(Amount)  -- Pivot, ��� ��������� ���� ������� �� ������� �� ����� (� �������)
	FOR ID_KS IN ([1]/*,[2] � �.�.*/)) AS PivotTable
	)


SELECT 
ROW_NUMBER() OVER(ORDER BY Acte.ID ASC) AS R#   -- ������ �����, ��� ���������� � Power BI, ��� ��� ��� �� �������������� ���������� �� hierarchyid
,Acte.ID.ToString() AS ID
,Acte.[����.�.]
,Acte.[������������ �����]
,Acte.[�������������]
,kscte.[��-1]
-- ,kscte.[��-2] � �.�.
,Acte.[��������� 1]
,Acte.[��������� 2]
,Acte.[��������� 3]

FROM AmountCTE Acte
LEFT JOIN KSCTE kscte ON Acte.ID=kscte.IDSmetPos
