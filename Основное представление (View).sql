
---- �������� ������������� ��� �������� � PowerBI

---- USE TNKFU

---- ALTER VIEW TNKFU AS  -- ��� ���������

------------ ���� CTE �������� ----------------------

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
	,cor.[����� COR] AS [����� COR]
	,ISNULL(cor.[����� COR],0)+ISNULL(ads.Amount,0) AS [���-�� � COR���]
	,idoc.[���� ��] AS [���� ��]
	,ISNULL(idoc.[���� ��],0) - ISNULL(n.�������������,0) AS [�������]
	,s.IDInd1 AS [��������� 1]
	,s.IDInd2 AS [��������� 2]
	,s.IDInd3 AS [��������� 3]
	,s.IDInd7 AS [��������� 7]
	,MaE.Code AS [ID ���������]
	,s.MAF
	,m.Status AS [������ MAF]
	,ar.�������
	,ar.�������������
	,ar.������ AS [������]

	FROM Smeta s
	
	JOIN Works w ON s.IDWorks=w.ID
	LEFT JOIN MAF m ON s.MAF=m.Number
			
			LEFT JOIN (/*
	
					����� ������������ ������-�� ����������� �C
					SUM ��� ���������� �� (����� ��������� �� �����)

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
	
					������������� �� ����� ������ ��. ����������� ������ ������, �� ���� �� ��������� � ��
	
			*/
				SELECT
				IDSmetPos,
				SUM(Amount) [�������������]
				FROM Amount_KS
				GROUP BY IDSmetPos
				) n
				ON s.IDSmetPos=n.IDSmetPos
			
			
			LEFT JOIN (/*
	
					������������� �� ����� ������ COR
	
			*/
				SELECT
				IDSmetPos,
				SUM(Amount) [����� COR]
				FROM Amount_COR
				GROUP BY IDSmetPos
				) cor
				ON s.IDSmetPos=cor.IDSmetPos
			
			LEFT JOIN (/*
	
					������������� �� ����� ������ ��. ����������� ������ ������, �� ���� �� ��������� � ��.
	
			*/
				SELECT
				IDSmetPos
				,SUM(Amount) AS [���� ��]
				FROM Amount_IDoc
				WHERE [ID_IDoc] IN (1)
				GROUP BY IDSmetPos
				) idoc
				ON s.IDSmetPos=idoc.IDSmetPos
			
			
			LEFT JOIN 
			
			Materials_and_Equipments MaE ON w.[IDMandEq]=MaE.ID
			
			LEFT JOIN (/*
	
					������������� �� ����� ������ ������. ����������� ������ ������, �� ���� �� ��������� � ��
	
			*/
				SELECT
				a_r.IDSmetPos
				,STRING_AGG(a_r.IDRequest,', ') [������]
				,SUM(a_r.Amount) [�������]
				,STRING_AGG(r.Responsible,', ') WITHIN GROUP ( ORDER BY r.Responsible ASC) [�������������]
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
					[������1],
					[������2]
				FROM (
					SELECT 
						IDSmetPos,
						Responsible,
						Amount
					FROM Amount_Request
				) AS SourceTable
				PIVOT (
					SUM(Amount)  
					FOR Responsible IN ([������1],[������2])
				) AS PivotTable
	)
	
	


----------------------------�������� ���� ������� �� ������������� CTE
SELECT 
ROW_NUMBER() OVER(ORDER BY Acte.ID ASC) AS R#   -- ������ �����, ��� ���������� � Power BI, ��� ��� ��� �� �������������� ���������� �� hierarchyid
,Acte.ID.ToString() AS ID
,Acte.[����.�.]
,Acte.[������������ �����]
,Acte.[���-�� �����]
,Acte.[���� ���.]
,Acte.[���� ���.]
,Acte.[�� ����]
,Acte.[���-�� �����]*Acte.[�� ����] AS [��������� �����]
,Acte.[�������������]
,Acte.[�������������]*Acte.[�� ����] AS [��������� ���.]
,Acte.[�������]
,Acte.[�������]*Acte.[�� ����] AS [��������� ���.]
,Acte.[����� COR]
,Acte.[���-�� � COR���]
,Acte.[���-�� � COR���]*Acte.[�� ����] AS [��������� c COR���]
,Acte.[��������� 1]
,Acte.[��������� 2]
,Acte.[��������� 3]
,Acte.[��������� 7]
,Acte.MAF
,Acte.[������ MAF]
,Acte.�������
,Acte.�������������
,Acte.������
,Reqcte.[������1]
,Reqcte.[������2]


FROM AmountCTE Acte
LEFT JOIN RequestCTE Reqcte ON Acte.ID=Reqcte.[IDSmetPos]
