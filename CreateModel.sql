
CREATE TABLE Smeta (

-- Ñîçäàåì òàáëèöó Ñìåòà, ãäå áóäóò õðàíèòñÿ Íîìåðà ñìåòíûõ ïîçèöèé, ñ ïðèâÿçêîé ê Ðàáîòàì è èíäèêàòîðàìè
	
	IDSmetPos hierarchyid NOT NULL CONSTRAINT PK_Smeta PRIMARY KEY
	,NameSmetPos nvarchar (20)
	,IDWorks int NOT NULL
	,IDInd1 int
	,IDInd2 int
	,IDInd3 int
	,IDInd7 int
	,MAF nvarchar(50))


CREATE TABLE Works (

-- Ñîçäàåì òàáëèöó ðàáîò. Â íåé áóäóò õðàíèòñÿ ðàçíûå ðàáîòû, ñ ñîêðàùåííûì è ïîëíûì íàèìåíîâàíèÿìè, åä. èçìåðåíèÿ è ID ìàòåðèàëà èëè îáîðóäîâàíèÿ

	ID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Works PRIMARY KEY -- ID Ðàáîòû
	,NameWork nvarchar (200) NOT NULL -- ñîêðàùåííîå íàèìåíîâàíèå ðàáîòû/ìàòåðèàëà/îáîðóäîâàíèÿ/ÏÍÐ è ïðî÷åãî
	,FulllNameWork nvarchar (2000) NULL -- ïîëíîå íàèìåíîâàíèå
	,Unit nvarchar(10) NULL -- åä. èçìåðåíèÿ
	,IDMandEq int null -- ID Ìàòåðèàëà èëè îáîðóäîâàíèÿ
	)

CREATE TABLE Materials_and_Equipments(

-- Ñîçäàåì òàáëèöó Ìàòåðèàëîâ è Îáîðóäîâàíèÿ. Â íåé áóäóò õðàíèòñÿ íàèìåíîâàíèÿ è èíôîðìàöèÿ ïî ìàòåðèàëàì èëè îáîðóäîâàíèþ.

	ID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Materiasl_and_Equipments PRIMARY KEY -- ID ìàòåðèàëà èëè îáîðóäîâàíèÿ
	,Name nvarchar(1000) NOT NULL -- Íàèìåíîâàíèå ìàòåðèàëà èëè îáðóäîâàíèÿ
	,OtherName nvarchar(1000) -- Äîïîëíèòåëüíîå íàèìåíîâàíèå
	,Code nvarchar(20) -- êîä íîìåíêëàòóðû ïîñòàâùèêà
	,OtherCode nvarchar(20) -- äîïîëíèòåëüíû êîä íîìåíêëàòóðû
	,Manufacturers nvarchar(1000) -- Ïðîèçâîäèòåëü, åñëè óêàçàí
)

CREATE TABLE DS (
-- Ñîçäàåì òàáëèöó Äîï. Ñîãëàøåíèé. Çäåñü òîëüêî íîìåðà ÄÑ, äàòû è êîììåíòàðèè.
	ID int NOT NULL CONSTRAINT PK_DS PRIMARY KEY -- ID äîï ñîãëàøåíèÿ
	,NumberDS nvarchar(10) NOT NULL -- Ïîðÿäêîéâûé íîìåð ÄÑ
	,Date date NOT NULL -- Äàòà ïîäïèñàíèÿ ÄÑ
	,Comments nvarchar(1000)) 

CREATE TABLE KS (
-- Ñîçäàåì òàáëèöó çàêðûòèé ïî ôîðìå ÊÑ2,3. Çäåñü òîëüêî íîìåð ÊÑ è äàòà ñ êîììåíòàðèÿìè.
	ID int NOT NULL CONSTRAINT PK_KS PRIMARY KEY 
	,NumberDS nvarchar(10) NOT NULL -- Ïîðÿäêîéâûé íîìåð ÊÑ
	,Date date NOT NULL -- Äàòà ïîäïèñàíèÿ ÊÑ
	,Comments nvarchar(1000))

CREATE TABLE Amount_DS (
-- Ñîçäàåì òàáëèöó ñ îáúåìàìè ïî ÄÑ èëè ñìåòå. Ñ öåíîé ìàòåðèàëîâ è ðàáîò. Ïðèâÿçûâàåì ê Ñìåòíîé ïîçèöèè è îïðåäåëåííîìó ÄÑ.
	IDSmetPos hierarchyid NOT NULL -- ID ñìåòíîé ïîçèöèè èç òàáëèöû Smeta
	,ID_DS int NOT NULL -- ID ÄÑ èç òàáëèöû DS
	,Amount float NULL -- Êîëè÷åñòâî îáúåìà 
	,Material_price money NULL -- Ñòîèìîñòü ìàòåðèàëà, òèï äàííûõ äåíåæíûé
	,Work_price money NULL -- Ñòîèìîñòü ðàáîò, òèï äàííûõ äåíåæíûé
	,CONSTRAINT FK_Amount_DS_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos) -- îãðàíè÷åèíå íà äîáàâëåíèå ID ñìåòíîé ïîçèöèè êîòîðîé íåò â Smeta
	,CONSTRAINT FK_Amount_DS_ID_DS FOREIGN KEY (ID_DS) REFERENCES DS (ID)) -- îãðàíè÷åèíå íà äîáàâëåíèå ID ÄÑ êîòîðîãî íåò â DS

CREATE TABLE Amount_KS (
-- Òàáëèöà îáúåìîâ ê òàáëèöå KS. Çäåñü òîëüêî êîëè÷åñòâî.
	IDSmetPos hierarchyid NOT NULL -- ID ñìåòíîé ïîçèöèè èç òàáëèöû Smeta
	,ID_KS int NOT NULL -- ID ÊÑ èç òàáëèöû KS
	,Amount float NOT NULL -- êîëè÷åñòâî îáúåìà
	,CONSTRAINT FK_Amount_KS_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos) -- îãðàíè÷åèíå íà äîáàâëåíèå ID ñìåòíîé ïîçèöèè êîòîðîé íåò â Smeta
	,CONSTRAINT FK_Amount_KS_KS_ID FOREIGN KEY (ID_KS) REFERENCES KS (ID)) -- îãðàíè÷åèíå íà äîáàâëåíèå ID ÊÑ êîòîðîãî íåò â KS


CREATE TABLE COR (
-- Òàáëèöà CORîâ.
	ID int NOT NULL CONSTRAINT PK_COR PRIMARY KEY
	,NumberCOR nvarchar(20) NOT NULL -- íîìåð CORà
	,Date date -- Äàòà îòïðàâêè
	,Name nvarchar(1000) 
	,Author nvarchar(50) --Àâòîð CORà
	,IDInd4 int NULL  -- Èíäèêàòîð 4
	,IDInd5 int NULL  -- Èíäèêàòîð 5
	,IDInd6 int NULL  -- Èíäèêàòîð 6
	,IDNumDS int null  -- íîìåð ÄÑ â êîòîðûé ïîïàë êîð
	,Comments nvarchar(2000) null) -- êîììåíòàðèé ê êîðó

CREATE TABLE Amount_COR (
-- Òàáëèöà îáúåìîâ ê òàáëèöå COR
	IDSmetPos hierarchyid NOT NULL -- ID ñìåòíîé ïîçèöèè èç òàáëèöû Smeta
	,ID_COR int NOT NULL -- ID CORà
	,Amount float NOT NULL -- êîëè÷åñòâî îáúåìà
	,Material_price money NULL -- Ñòîèìîñòü ìàòåðèàëà, òèï äàííûõ äåíåæíûé
	,Work_price money NULL -- Ñòîèìîñòü ðàáîò, òèï äàííûõ äåíåæíûé
	,CONSTRAINT FK_Amount_COR_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos)
	,CONSTRAINT FK_Amount_COR_ID_COR FOREIGN KEY (ID_COR) REFERENCES COR (ID))

CREATE TABLE IDoc (
-- Òàáëèöà ôàéëîâ Èñïîëíèòåëüíîé Äîêóìåíòàöèè. 
	ID int NOT NULL CONSTRAINT PK_IDoc PRIMARY KEY
	,NameDoc nvarchar(300) NOT NULL -- Íàèìåíâîàèíå äîêóìåíòà
	,Date date NOT NULL-- Äàòà ñîçäàíèÿ äîêóìåíòà
	,Comments nvarchar(1000)
	)

CREATE TABLE Amount_IDoc (
-- Òàáëèöà îáúåìîâ äëÿ òàáëèöû IDoc
	IDSmetPos hierarchyid NOT NULL -- ID ñìåòíîé ïîçèöèè èç òàáëèöû Smeta
	,ID_IDoc int NOT NULL
	,Amount float NOT NULL -- êîëè÷åñòâî îáúåìà
	,NumberPos int NULL -- Íîìåð ñòðîêè â äîêóìåíòå
	,CONSTRAINT FK_Amount_IDoc_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos)
	,CONSTRAINT FK_Amount_IDoc_ID_IDoc FOREIGN KEY (ID_IDoc) REFERENCES IDoc (ID))

CREATE TABLE RDoc (
-- Òàáëèöà ôàéëîâ Ðàáî÷åé Äîêóìåíòàöèè. 
	ID int NOT NULL CONSTRAINT PK_RDoc PRIMARY KEY
	,NameDoc nvarchar(300) NOT NULL -- Íàèìåíâîàèíå äîêóìåíòà
	,Date date NOT NULL-- Äàòà ñîçäàíèÿ äîêóìåíòà
	,Comments nvarchar(1000)
	)

CREATE TABLE Amount_RDoc (
-- Òàáëèöà îáúåìîâ äëÿ òàáëèöû RDoc
	IDSmetPos hierarchyid NOT NULL -- ID ñìåòíîé ïîçèöèè èç òàáëèöû Smeta
	,ID_RDoc int NOT NULL
	,Amount float NOT NULL -- êîëè÷åñòâî îáúåìà
	,NumberPos int NULL -- Íîìåð ñòðîêè â äîêóìåíòå
	,CONSTRAINT FK_Amount_RDoc_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos)
	,CONSTRAINT FK_Amount_RDoc_ID_RDoc FOREIGN KEY (ID_RDoc) REFERENCES RDoc (ID))

CREATE TABLE Request (
-- Òàáëèöà ñ äàòîé ïî çàÿâêàì
	IDRequest int not null CONSTRAINT PK_Request PRIMARY KEY   -- ID çàÿâêè
	,DateReques date null										-- Äàòà çàâåäåíèÿ çàÿâêè
	,DateApproval date null										-- Äàòà ñîãëàñîâàíèÿ ñ÷åòà ïî çàÿâêå
	,DatePayment date null										-- Äàòà ïëàòû ñ÷åòà ïî çàÿâêå
	,StatusRequest nvarchar(200) null							-- Ñòàòóñ çàÿâêè/ñ÷åòà
	,Responsible  nvarchar(50) NOT NULL							-- Îòâåòñâåííûé
	,Note  nvarchar(500) null									-- Ïðèìå÷àíðíèå
	)



CREATE TABLE Amount_Request (
-- Òàáëèöà îáúåìîâ äëÿ òàáëèöû RDoc
	IDSmetPos hierarchyid NOT NULL -- ID ñìåòíîé ïîçèöèè èç òàáëèöû Smeta
	,IDRequest int NOT NULL
	,Amount float NOT NULL -- êîëè÷åñòâî îáúåìà
	,Material_price money NULL -- Ñòîèìîñòü ìàòåðèàëà, òèï äàííûõ äåíåæíûé
	,Budget_Item nvarchar(200) null  --ñòàòüÿ ðàñõîäîâ, îïöèîíàëüíî
	,Responsible  nvarchar(50) NOT NULL  -- Îòâåòñâåííûé
	,CONSTRAINT FK_Amount_Request_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos)
	,CONSTRAINT FK_Amount_Request_IDRequest FOREIGN KEY (IDRequest) REFERENCES Request (IDRequest))


CREATE TABLE Indicator1 (
-- Òàáëèöà èíäèêàòîðîâ 1. Ðàçäåëåíèå íà ñìåòû (ÑÌÐ òèïîâûå, äèñïåò÷åðèçàöèÿ, VIP è ïðî÷åå)
	ID int  NOT NULL CONSTRAINT PK_Indicator1 PRIMARY KEY
	,Name nvarchar(500)) -- Íàèìåíîâàíèå èíäèêàòîðà

CREATE TABLE Indicator2 (
-- Òàáëèöà èíäèêàòîðîâ 2. Ðàçäåëåíèå íà áîëåå äåòàëüíûå ãðóïïû (ñèñòåìû, îòäåëüíûå ãðóïïû ðàáîò è ïðî÷åå)
	ID int  NOT NULL CONSTRAINT PK_Indicator2 PRIMARY KEY
	,Name nvarchar(500)
	,Comment nvarchar(500) NULL) -- Íàèìåíîâàíèå èíäèêàòîðà

CREATE TABLE Indicator3 (
-- Òàáëèöà èíäèêàòîðîâ 3.
	ID int  NOT NULL CONSTRAINT PK_Indicator3 PRIMARY KEY
	,Name nvarchar(500)) -- Íàèìåíîâàíèå èíäèêàòîðà


CREATE TABLE Indicator4 (
-- Òàáëèöà èíäèêàòîðîâ 4, äëÿ CORîâ, ñòàòóñ CORa
	ID int not null CONSTRAINT PR_Indicator4 PRIMARY KEY
	,Name nvarchar(500) null)

CREATE TABLE Indicator5 (
-- Òàáëèöà èíäèêàòîðîâ 5, äëÿ CORîâ, ñòàòóñ CORa
	ID int not null CONSTRAINT PR_Indicator5 PRIMARY KEY
	,Name nvarchar(500) null)

CREATE TABLE Indicator6 (
-- Òàáëèöà èíäèêàòîðîâ 6, äëÿ CORîâ, íàïðàâëåíèå ÀÐ, ÈÑ, ÑÑ
	ID int not null CONSTRAINT PR_Indicator6 PRIMARY KEY
	,Name nvarchar(500) null)

CREATE TABLE NumDS (
-- Òàáëèöà íîìåðîâ ÄÑ, äëÿ CORîâ, ÄÑ 33, ÄÑ32 è ò.ä.
	ID int not null CONSTRAINT PR_NumDS PRIMARY KEY
	,Name nvarchar(50) null)

CREATE TABLE Indicator7 (
-- Òàáëèöà èíäèêàòîðîâ 7, íàïðàâëåíèå ÀÐ, ÈÑ, ÑÑ
	ID int not null CONSTRAINT PR_Indicator7 PRIMARY KEY
	,Name nvarchar(100) null)
	
CREATE TABLE MAF (
-- Òàáëèöà èíäèêàòîðîâ 7, íàïðàâëåíèå ÀÐ, ÈÑ, ÑÑ
	Number nvarchar(50) not null CONSTRAINT PR_MAF PRIMARY KEY
	,Name nvarchar(1000) null
	,Date date null
	,DateSupply nvarchar(1000) null
	,Status nvarchar(200) null)


ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_IDWorks FOREIGN KEY (IDWorks) REFERENCES Works(ID) -- îãðàíèå÷åíèå íà äîáàâëåíèå ID ðàáîò êîòîðûõ íåò â òàáëèöå ðàáîò
ALTER TABLE Works ADD CONSTRAINT FK_Works_M_and_Eq_ID FOREIGN KEY (IDMandEq) REFERENCES Materials_and_Equipments (ID) 
-- îãðàíèå÷åíèå íà äîáàâëåíèå ID Ìàòåðèëà èëè îáîðóäîâàíèÿ êîòàáîòîðûõ íåò â òàáëèöå Ìàòåðèàëîâ è Îáîðóäîâàíèÿ
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_Indicator1 FOREIGN KEY (IDInd1) REFERENCES Indicator1(ID) -- îãðàíèå÷åíèå íà äîáàâëåíèå ID èíäèêàòîðà 1 êîòîðûõ íåò â òàáëèöå Indicator1 
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_Indicator2 FOREIGN KEY (IDInd2) REFERENCES Indicator2(ID) -- îãðàíèå÷åíèå íà äîáàâëåíèå ID èíäèêàòîðà 2 êîòîðûõ íåò â òàáëèöå Indicator2
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_Indicator3 FOREIGN KEY (IDInd3) REFERENCES Indicator3(ID) -- îãðàíèå÷åíèå íà äîáàâëåíèå ID èíäèêàòîðà 3 êîòîðûõ íåò â òàáëèöå Indicator3
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_Indicator7 FOREIGN KEY (IDInd7) REFERENCES Indicator7(ID) -- îãðàíèå÷åíèå íà äîáàâëåíèå ID èíäèêàòîðà 7 êîòîðûõ íåò â òàáëèöå Indicator7
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_MAF FOREIGN KEY (MAF) REFERENCES MAF(Number) -- îãðàíèå÷åíèå íà äîáàâëåíèå ID èíäèêàòîðà 7 êîòîðûõ íåò â òàáëèöå Indicator7
ALTER TABLE COR ADD CONSTRAINT FK_COR_Indicator4 FOREIGN KEY (IDInd4) REFERENCES Indicator4(ID) -- îãðàíèå÷åíèå íà äîáàâëåíèå ID èíäèêàòîðà 4 êîòîðûõ íåò â òàáëèöå Indicator4
ALTER TABLE COR ADD CONSTRAINT FK_COR_Indicator5 FOREIGN KEY (IDInd5) REFERENCES Indicator5(ID) -- îãðàíèå÷åíèå íà äîáàâëåíèå ID èíäèêàòîðà 5 êîòîðûõ íåò â òàáëèöå Indicator5
ALTER TABLE COR ADD CONSTRAINT FK_COR_Indicator6 FOREIGN KEY (IDInd6) REFERENCES Indicator6(ID) -- îãðàíèå÷åíèå íà äîáàâëåíèå ID èíäèêàòîðà 6 êîòîðûõ íåò â òàáëèöå Indicator6
ALTER TABLE COR ADD CONSTRAINT FK_COR_NumDS FOREIGN KEY (IDNumDS) REFERENCES NumDS(ID)  -- îãðàíèå÷åíèå íà äîáàâëåíèå ID ÄÑ êîòîðûõ íåò â òàáëèöå DS

CREATE TABLE LoadTable (
-- Òàáëèöà äëÿ çàãðóçêè äàííûõ
	A1 nvarchar(100)
	,A2 nvarchar(2000)
	,A3 nvarchar(200)
	,A4 float
	,A5 float
	,A6 float
	,A7 varchar(100)
)

