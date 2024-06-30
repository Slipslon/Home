
CREATE TABLE Smeta (

-- ������� ������� �����, ��� ����� �������� ������ ������� �������, � ��������� � ������� � ������������
	
	IDSmetPos hierarchyid NOT NULL CONSTRAINT PK_Smeta PRIMARY KEY
	,NameSmetPos nvarchar (20)
	,IDWorks int NOT NULL
	,IDInd1 int
	,IDInd2 int
	,IDInd3 int
	,IDInd7 int
	,MAF nvarchar(50))


CREATE TABLE Works (

-- ������� ������� �����. � ��� ����� �������� ������ ������, � ����������� � ������ ��������������, ��. ��������� � ID ��������� ��� ������������

	ID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Works PRIMARY KEY -- ID ������
	,NameWork nvarchar (200) NOT NULL -- ����������� ������������ ������/���������/������������/��� � �������
	,FulllNameWork nvarchar (2000) NULL -- ������ ������������
	,Unit nvarchar(10) NULL -- ��. ���������
	,IDMandEq int null -- ID ��������� ��� ������������
	)

CREATE TABLE Materials_and_Equipments(

-- ������� ������� ���������� � ������������. � ��� ����� �������� ������������ � ���������� �� ���������� ��� ������������.

	ID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Materiasl_and_Equipments PRIMARY KEY -- ID ��������� ��� ������������
	,Name nvarchar(1000) NOT NULL -- ������������ ��������� ��� �����������
	,OtherName nvarchar(1000) -- �������������� ������������
	,Code nvarchar(20) -- ��� ������������ ����������
	,OtherCode nvarchar(20) -- ������������� ��� ������������
	,Manufacturers nvarchar(1000) -- �������������, ���� ������
)

CREATE TABLE DS (
-- ������� ������� ���. ����������. ����� ������ ������ ��, ���� � �����������.
	ID int NOT NULL CONSTRAINT PK_DS PRIMARY KEY -- ID ��� ����������
	,NumberDS nvarchar(10) NOT NULL -- ����������� ����� ��
	,Date date NOT NULL -- ���� ���������� ��
	,Comments nvarchar(1000)) 

CREATE TABLE KS (
-- ������� ������� �������� �� ����� ��2,3. ����� ������ ����� �� � ���� � �������������.
	ID int NOT NULL CONSTRAINT PK_KS PRIMARY KEY 
	,NumberDS nvarchar(10) NOT NULL -- ����������� ����� ��
	,Date date NOT NULL -- ���� ���������� ��
	,Comments nvarchar(1000))

CREATE TABLE Amount_DS (
-- ������� ������� � �������� �� �� ��� �����. � ����� ���������� � �����. ����������� � ������� ������� � ������������� ��.
	IDSmetPos hierarchyid NOT NULL -- ID ������� ������� �� ������� Smeta
	,ID_DS int NOT NULL -- ID �� �� ������� DS
	,Amount float NULL -- ���������� ������ 
	,Material_price money NULL -- ��������� ���������, ��� ������ ��������
	,Work_price money NULL -- ��������� �����, ��� ������ ��������
	,CONSTRAINT FK_Amount_DS_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos) -- ����������� �� ���������� ID ������� ������� ������� ��� � Smeta
	,CONSTRAINT FK_Amount_DS_ID_DS FOREIGN KEY (ID_DS) REFERENCES DS (ID)) -- ����������� �� ���������� ID �� �������� ��� � DS

CREATE TABLE Amount_KS (
-- ������� ������� � ������� KS. ����� ������ ����������.
	IDSmetPos hierarchyid NOT NULL -- ID ������� ������� �� ������� Smeta
	,ID_KS int NOT NULL -- ID �� �� ������� KS
	,Amount float NOT NULL -- ���������� ������
	,CONSTRAINT FK_Amount_KS_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos) -- ����������� �� ���������� ID ������� ������� ������� ��� � Smeta
	,CONSTRAINT FK_Amount_KS_KS_ID FOREIGN KEY (ID_KS) REFERENCES KS (ID)) -- ����������� �� ���������� ID �� �������� ��� � KS


CREATE TABLE COR (
-- ������� COR��.
	ID int NOT NULL CONSTRAINT PK_COR PRIMARY KEY
	,NumberCOR nvarchar(20) NOT NULL -- ����� COR�
	,Date date -- ���� ��������
	,Name nvarchar(1000) 
	,Author nvarchar(50) --����� COR�
	,IDInd4 int NULL  -- ��������� 4
	,IDInd5 int NULL  -- ��������� 5
	,IDInd6 int NULL  -- ��������� 6
	,IDNumDS int null  -- ����� �� � ������� ����� ���
	,Comments nvarchar(2000) null) -- ����������� � ����

CREATE TABLE Amount_COR (
-- ������� ������� � ������� COR
	IDSmetPos hierarchyid NOT NULL -- ID ������� ������� �� ������� Smeta
	,ID_COR int NOT NULL -- ID COR�
	,Amount float NOT NULL -- ���������� ������
	,Material_price money NULL -- ��������� ���������, ��� ������ ��������
	,Work_price money NULL -- ��������� �����, ��� ������ ��������
	,CONSTRAINT FK_Amount_COR_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos)
	,CONSTRAINT FK_Amount_COR_ID_COR FOREIGN KEY (ID_COR) REFERENCES COR (ID))

CREATE TABLE IDoc (
-- ������� ������ �������������� ������������. 
	ID int NOT NULL CONSTRAINT PK_IDoc PRIMARY KEY
	,NameDoc nvarchar(300) NOT NULL -- ������������ ���������
	,Date date NOT NULL-- ���� �������� ���������
	,Comments nvarchar(1000)
	)

CREATE TABLE Amount_IDoc (
-- ������� ������� ��� ������� IDoc
	IDSmetPos hierarchyid NOT NULL -- ID ������� ������� �� ������� Smeta
	,ID_IDoc int NOT NULL
	,Amount float NOT NULL -- ���������� ������
	,NumberPos int NULL -- ����� ������ � ���������
	,CONSTRAINT FK_Amount_IDoc_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos)
	,CONSTRAINT FK_Amount_IDoc_ID_IDoc FOREIGN KEY (ID_IDoc) REFERENCES IDoc (ID))

CREATE TABLE RDoc (
-- ������� ������ ������� ������������. 
	ID int NOT NULL CONSTRAINT PK_RDoc PRIMARY KEY
	,NameDoc nvarchar(300) NOT NULL -- ������������ ���������
	,Date date NOT NULL-- ���� �������� ���������
	,Comments nvarchar(1000)
	)

CREATE TABLE Amount_RDoc (
-- ������� ������� ��� ������� RDoc
	IDSmetPos hierarchyid NOT NULL -- ID ������� ������� �� ������� Smeta
	,ID_RDoc int NOT NULL
	,Amount float NOT NULL -- ���������� ������
	,NumberPos int NULL -- ����� ������ � ���������
	,CONSTRAINT FK_Amount_RDoc_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos)
	,CONSTRAINT FK_Amount_RDoc_ID_RDoc FOREIGN KEY (ID_RDoc) REFERENCES RDoc (ID))

CREATE TABLE Request (
-- ������� � ����� �� �������
	IDRequest int not null CONSTRAINT PK_Request PRIMARY KEY   -- ID ������
	,DateReques date null										-- ���� ��������� ������
	,DateApproval date null										-- ���� ������������ ����� �� ������
	,DatePayment date null										-- ���� ����� ����� �� ������
	,StatusRequest nvarchar(200) null							-- ������ ������/�����
	,Responsible  nvarchar(50) NOT NULL							-- ������������
	,Note  nvarchar(500) null									-- ������������
	)



CREATE TABLE Amount_Request (
-- ������� ������� ��� ������� RDoc
	IDSmetPos hierarchyid NOT NULL -- ID ������� ������� �� ������� Smeta
	,IDRequest int NOT NULL
	,Amount float NOT NULL -- ���������� ������
	,Material_price money NULL -- ��������� ���������, ��� ������ ��������
	,Budget_Item nvarchar(200) null  --������ ��������, �����������
	,Responsible  nvarchar(50) NOT NULL  -- ������������
	,CONSTRAINT FK_Amount_Request_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos)
	,CONSTRAINT FK_Amount_Request_IDRequest FOREIGN KEY (IDRequest) REFERENCES Request (IDRequest))


CREATE TABLE Indicator1 (
-- ������� ����������� 1. ���������� �� ����� (��� �������, ���������������, VIP � ������)
	ID int  NOT NULL CONSTRAINT PK_Indicator1 PRIMARY KEY
	,Name nvarchar(500)) -- ������������ ����������

CREATE TABLE Indicator2 (
-- ������� ����������� 2. ���������� �� ����� ��������� ������ (�������, ��������� ������ ����� � ������)
	ID int  NOT NULL CONSTRAINT PK_Indicator2 PRIMARY KEY
	,Name nvarchar(500)
	,Comment nvarchar(500) NULL) -- ������������ ����������

CREATE TABLE Indicator3 (
-- ������� ����������� 3.
	ID int  NOT NULL CONSTRAINT PK_Indicator3 PRIMARY KEY
	,Name nvarchar(500)) -- ������������ ����������


CREATE TABLE Indicator4 (
-- ������� ����������� 4, ��� COR��, ������ CORa
	ID int not null CONSTRAINT PR_Indicator4 PRIMARY KEY
	,Name nvarchar(500) null)

CREATE TABLE Indicator5 (
-- ������� ����������� 5, ��� COR��, ������ CORa
	ID int not null CONSTRAINT PR_Indicator5 PRIMARY KEY
	,Name nvarchar(500) null)

CREATE TABLE Indicator6 (
-- ������� ����������� 6, ��� COR��, ����������� ��, ��, ��
	ID int not null CONSTRAINT PR_Indicator6 PRIMARY KEY
	,Name nvarchar(500) null)

CREATE TABLE NumDS (
-- ������� ������� ��, ��� COR��, �� 33, ��32 � �.�.
	ID int not null CONSTRAINT PR_NumDS PRIMARY KEY
	,Name nvarchar(50) null)

CREATE TABLE Indicator7 (
-- ������� ����������� 7, ����������� ��, ��, ��
	ID int not null CONSTRAINT PR_Indicator7 PRIMARY KEY
	,Name nvarchar(100) null)
	
CREATE TABLE MAF (
-- ������� ����������� 7, ����������� ��, ��, ��
	Number nvarchar(50) not null CONSTRAINT PR_MAF PRIMARY KEY
	,Name nvarchar(1000) null
	,Date date null
	,DateSupply nvarchar(1000) null
	,Status nvarchar(200) null)


ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_IDWorks FOREIGN KEY (IDWorks) REFERENCES Works(ID) -- ������������ �� ���������� ID ����� ������� ��� � ������� �����
ALTER TABLE Works ADD CONSTRAINT FK_Works_M_and_Eq_ID FOREIGN KEY (IDMandEq) REFERENCES Materials_and_Equipments (ID) 
-- ������������ �� ���������� ID �������� ��� ������������ ����������� ��� � ������� ���������� � ������������
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_Indicator1 FOREIGN KEY (IDInd1) REFERENCES Indicator1(ID) -- ������������ �� ���������� ID ���������� 1 ������� ��� � ������� Indicator1 
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_Indicator2 FOREIGN KEY (IDInd2) REFERENCES Indicator2(ID) -- ������������ �� ���������� ID ���������� 2 ������� ��� � ������� Indicator2
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_Indicator3 FOREIGN KEY (IDInd3) REFERENCES Indicator3(ID) -- ������������ �� ���������� ID ���������� 3 ������� ��� � ������� Indicator3
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_Indicator7 FOREIGN KEY (IDInd7) REFERENCES Indicator7(ID) -- ������������ �� ���������� ID ���������� 7 ������� ��� � ������� Indicator7
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_MAF FOREIGN KEY (MAF) REFERENCES MAF(Number) -- ������������ �� ���������� ID ���������� 7 ������� ��� � ������� Indicator7
ALTER TABLE COR ADD CONSTRAINT FK_COR_Indicator4 FOREIGN KEY (IDInd4) REFERENCES Indicator4(ID) -- ������������ �� ���������� ID ���������� 4 ������� ��� � ������� Indicator4
ALTER TABLE COR ADD CONSTRAINT FK_COR_Indicator5 FOREIGN KEY (IDInd5) REFERENCES Indicator5(ID) -- ������������ �� ���������� ID ���������� 5 ������� ��� � ������� Indicator5
ALTER TABLE COR ADD CONSTRAINT FK_COR_Indicator6 FOREIGN KEY (IDInd6) REFERENCES Indicator6(ID) -- ������������ �� ���������� ID ���������� 6 ������� ��� � ������� Indicator6
ALTER TABLE COR ADD CONSTRAINT FK_COR_NumDS FOREIGN KEY (IDNumDS) REFERENCES NumDS(ID)  -- ������������ �� ���������� ID �� ������� ��� � ������� DS

CREATE TABLE LoadTable (
-- ������� ��� �������� ������
	A1 nvarchar(100)
	,A2 nvarchar(2000)
	,A3 nvarchar(200)
	,A4 float
	,A5 float
	,A6 float
	,A7 varchar(100)
)

