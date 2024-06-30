
CREATE TABLE Smeta (

-- Создаем таблицу Смета, где будут хранится Номера сметных позиций, с привязкой к Работам и индикаторами
	
	IDSmetPos hierarchyid NOT NULL CONSTRAINT PK_Smeta PRIMARY KEY
	,NameSmetPos nvarchar (20)
	,IDWorks int NOT NULL
	,IDInd1 int
	,IDInd2 int
	,IDInd3 int
	,IDInd7 int
	,MAF nvarchar(50))


CREATE TABLE Works (

-- Создаем таблицу работ. В ней будут хранится разные работы, с сокращенным и полным наименованиями, ед. измерения и ID материала или оборудования

	ID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Works PRIMARY KEY -- ID Работы
	,NameWork nvarchar (200) NOT NULL -- сокращенное наименование работы/материала/оборудования/ПНР и прочего
	,FulllNameWork nvarchar (2000) NULL -- полное наименование
	,Unit nvarchar(10) NULL -- ед. измерения
	,IDMandEq int null -- ID Материала или оборудования
	)

CREATE TABLE Materials_and_Equipments(

-- Создаем таблицу Материалов и Оборудования. В ней будут хранится наименования и информация по материалам или оборудованию.

	ID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Materiasl_and_Equipments PRIMARY KEY -- ID материала или оборудования
	,Name nvarchar(1000) NOT NULL -- Наименование материала или обрудования
	,OtherName nvarchar(1000) -- Дополнительное наименование
	,Code nvarchar(20) -- код номенклатуры поставщика
	,OtherCode nvarchar(20) -- дополнительны код номенклатуры
	,Manufacturers nvarchar(1000) -- Производитель, если указан
)

CREATE TABLE DS (
-- Создаем таблицу Доп. Соглашений. Здесь только номера ДС, даты и комментарии.
	ID int NOT NULL CONSTRAINT PK_DS PRIMARY KEY -- ID доп соглашения
	,NumberDS nvarchar(10) NOT NULL -- Порядкойвый номер ДС
	,Date date NOT NULL -- Дата подписания ДС
	,Comments nvarchar(1000)) 

CREATE TABLE KS (
-- Создаем таблицу закрытий по форме КС2,3. Здесь только номер КС и дата с комментариями.
	ID int NOT NULL CONSTRAINT PK_KS PRIMARY KEY 
	,NumberDS nvarchar(10) NOT NULL -- Порядкойвый номер КС
	,Date date NOT NULL -- Дата подписания КС
	,Comments nvarchar(1000))

CREATE TABLE Amount_DS (
-- Создаем таблицу с объемами по ДС или смете. С ценой материалов и работ. Привязываем к Сметной позиции и определенному ДС.
	IDSmetPos hierarchyid NOT NULL -- ID сметной позиции из таблицы Smeta
	,ID_DS int NOT NULL -- ID ДС из таблицы DS
	,Amount float NULL -- Количество объема 
	,Material_price money NULL -- Стоимость материала, тип данных денежный
	,Work_price money NULL -- Стоимость работ, тип данных денежный
	,CONSTRAINT FK_Amount_DS_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos) -- ограничеине на добавление ID сметной позиции которой нет в Smeta
	,CONSTRAINT FK_Amount_DS_ID_DS FOREIGN KEY (ID_DS) REFERENCES DS (ID)) -- ограничеине на добавление ID ДС которого нет в DS

CREATE TABLE Amount_KS (
-- Таблица объемов к таблице KS. Здесь только количество.
	IDSmetPos hierarchyid NOT NULL -- ID сметной позиции из таблицы Smeta
	,ID_KS int NOT NULL -- ID КС из таблицы KS
	,Amount float NOT NULL -- количество объема
	,CONSTRAINT FK_Amount_KS_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos) -- ограничеине на добавление ID сметной позиции которой нет в Smeta
	,CONSTRAINT FK_Amount_KS_KS_ID FOREIGN KEY (ID_KS) REFERENCES KS (ID)) -- ограничеине на добавление ID КС которого нет в KS


CREATE TABLE COR (
-- Таблица CORов.
	ID int NOT NULL CONSTRAINT PK_COR PRIMARY KEY
	,NumberCOR nvarchar(20) NOT NULL -- номер CORа
	,Date date -- Дата отправки
	,Name nvarchar(1000) 
	,Author nvarchar(50) --Автор CORа
	,IDInd4 int NULL  -- Индикатор 4
	,IDInd5 int NULL  -- Индикатор 5
	,IDInd6 int NULL  -- Индикатор 6
	,IDNumDS int null  -- номер ДС в который попал кор
	,Comments nvarchar(2000) null) -- комментарий к кору

CREATE TABLE Amount_COR (
-- Таблица объемов к таблице COR
	IDSmetPos hierarchyid NOT NULL -- ID сметной позиции из таблицы Smeta
	,ID_COR int NOT NULL -- ID CORа
	,Amount float NOT NULL -- количество объема
	,Material_price money NULL -- Стоимость материала, тип данных денежный
	,Work_price money NULL -- Стоимость работ, тип данных денежный
	,CONSTRAINT FK_Amount_COR_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos)
	,CONSTRAINT FK_Amount_COR_ID_COR FOREIGN KEY (ID_COR) REFERENCES COR (ID))

CREATE TABLE IDoc (
-- Таблица файлов Исполнительной Документации. 
	ID int NOT NULL CONSTRAINT PK_IDoc PRIMARY KEY
	,NameDoc nvarchar(300) NOT NULL -- Наименвоаине документа
	,Date date NOT NULL-- Дата создания документа
	,Comments nvarchar(1000)
	)

CREATE TABLE Amount_IDoc (
-- Таблица объемов для таблицы IDoc
	IDSmetPos hierarchyid NOT NULL -- ID сметной позиции из таблицы Smeta
	,ID_IDoc int NOT NULL
	,Amount float NOT NULL -- количество объема
	,NumberPos int NULL -- Номер строки в документе
	,CONSTRAINT FK_Amount_IDoc_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos)
	,CONSTRAINT FK_Amount_IDoc_ID_IDoc FOREIGN KEY (ID_IDoc) REFERENCES IDoc (ID))

CREATE TABLE RDoc (
-- Таблица файлов Рабочей Документации. 
	ID int NOT NULL CONSTRAINT PK_RDoc PRIMARY KEY
	,NameDoc nvarchar(300) NOT NULL -- Наименвоаине документа
	,Date date NOT NULL-- Дата создания документа
	,Comments nvarchar(1000)
	)

CREATE TABLE Amount_RDoc (
-- Таблица объемов для таблицы RDoc
	IDSmetPos hierarchyid NOT NULL -- ID сметной позиции из таблицы Smeta
	,ID_RDoc int NOT NULL
	,Amount float NOT NULL -- количество объема
	,NumberPos int NULL -- Номер строки в документе
	,CONSTRAINT FK_Amount_RDoc_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos)
	,CONSTRAINT FK_Amount_RDoc_ID_RDoc FOREIGN KEY (ID_RDoc) REFERENCES RDoc (ID))

CREATE TABLE Request (
-- Таблица с датой по заявкам
	IDRequest int not null CONSTRAINT PK_Request PRIMARY KEY   -- ID заявки
	,DateReques date null										-- Дата заведения заявки
	,DateApproval date null										-- Дата согласования счета по заявке
	,DatePayment date null										-- Дата платы счета по заявке
	,StatusRequest nvarchar(200) null							-- Статус заявки/счета
	,Responsible  nvarchar(50) NOT NULL							-- Ответсвенный
	,Note  nvarchar(500) null									-- Примечание
	)



CREATE TABLE Amount_Request (
-- Таблица объемов для таблицы RDoc
	IDSmetPos hierarchyid NOT NULL -- ID сметной позиции из таблицы Smeta
	,IDRequest int NOT NULL
	,Amount float NOT NULL -- количество объема
	,Material_price money NULL -- Стоимость материала, тип данных денежный
	,Budget_Item nvarchar(200) null  --статья расходов, опционально
	,Responsible  nvarchar(50) NOT NULL  -- Ответсвенный
	,CONSTRAINT FK_Amount_Request_IDSmetPos FOREIGN KEY (IDSmetPos) REFERENCES Smeta(IDSmetPos)
	,CONSTRAINT FK_Amount_Request_IDRequest FOREIGN KEY (IDRequest) REFERENCES Request (IDRequest))


CREATE TABLE Indicator1 (
-- Таблица индикаторов 1. Разделение на сметы (СМР типовые, диспетчеризация, VIP и прочее)
	ID int  NOT NULL CONSTRAINT PK_Indicator1 PRIMARY KEY
	,Name nvarchar(500)) -- Наименование индикатора

CREATE TABLE Indicator2 (
-- Таблица индикаторов 2. Разделение на более детальные группы (системы, отдельные группы работ и прочее)
	ID int  NOT NULL CONSTRAINT PK_Indicator2 PRIMARY KEY
	,Name nvarchar(500)
	,Comment nvarchar(500) NULL) -- Наименование индикатора

CREATE TABLE Indicator3 (
-- Таблица индикаторов 3.
	ID int  NOT NULL CONSTRAINT PK_Indicator3 PRIMARY KEY
	,Name nvarchar(500)) -- Наименование индикатора


CREATE TABLE Indicator4 (
-- Таблица индикаторов 4, для CORов, статус CORa
	ID int not null CONSTRAINT PR_Indicator4 PRIMARY KEY
	,Name nvarchar(500) null)

CREATE TABLE Indicator5 (
-- Таблица индикаторов 5, для CORов, статус CORa
	ID int not null CONSTRAINT PR_Indicator5 PRIMARY KEY
	,Name nvarchar(500) null)

CREATE TABLE Indicator6 (
-- Таблица индикаторов 6, для CORов, направление АР, ИС, СС
	ID int not null CONSTRAINT PR_Indicator6 PRIMARY KEY
	,Name nvarchar(500) null)

CREATE TABLE NumDS (
-- Таблица номеров ДС, для CORов, ДС 33, ДС32 и т.д.
	ID int not null CONSTRAINT PR_NumDS PRIMARY KEY
	,Name nvarchar(50) null)

CREATE TABLE Indicator7 (
-- Таблица индикаторов 7, направление АР, ИС, СС
	ID int not null CONSTRAINT PR_Indicator7 PRIMARY KEY
	,Name nvarchar(100) null)
	
CREATE TABLE MAF (
-- Таблица индикаторов 7, направление АР, ИС, СС
	Number nvarchar(50) not null CONSTRAINT PR_MAF PRIMARY KEY
	,Name nvarchar(1000) null
	,Date date null
	,DateSupply nvarchar(1000) null
	,Status nvarchar(200) null)


ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_IDWorks FOREIGN KEY (IDWorks) REFERENCES Works(ID) -- ограниечение на добавление ID работ которых нет в таблице работ
ALTER TABLE Works ADD CONSTRAINT FK_Works_M_and_Eq_ID FOREIGN KEY (IDMandEq) REFERENCES Materials_and_Equipments (ID) 
-- ограниечение на добавление ID Материла или оборудования котаботорых нет в таблице Материалов и Оборудования
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_Indicator1 FOREIGN KEY (IDInd1) REFERENCES Indicator1(ID) -- ограниечение на добавление ID индикатора 1 которых нет в таблице Indicator1 
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_Indicator2 FOREIGN KEY (IDInd2) REFERENCES Indicator2(ID) -- ограниечение на добавление ID индикатора 2 которых нет в таблице Indicator2
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_Indicator3 FOREIGN KEY (IDInd3) REFERENCES Indicator3(ID) -- ограниечение на добавление ID индикатора 3 которых нет в таблице Indicator3
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_Indicator7 FOREIGN KEY (IDInd7) REFERENCES Indicator7(ID) -- ограниечение на добавление ID индикатора 7 которых нет в таблице Indicator7
ALTER TABLE Smeta ADD CONSTRAINT FK_Smeta_MAF FOREIGN KEY (MAF) REFERENCES MAF(Number) -- ограниечение на добавление ID индикатора 7 которых нет в таблице Indicator7
ALTER TABLE COR ADD CONSTRAINT FK_COR_Indicator4 FOREIGN KEY (IDInd4) REFERENCES Indicator4(ID) -- ограниечение на добавление ID индикатора 4 которых нет в таблице Indicator4
ALTER TABLE COR ADD CONSTRAINT FK_COR_Indicator5 FOREIGN KEY (IDInd5) REFERENCES Indicator5(ID) -- ограниечение на добавление ID индикатора 5 которых нет в таблице Indicator5
ALTER TABLE COR ADD CONSTRAINT FK_COR_Indicator6 FOREIGN KEY (IDInd6) REFERENCES Indicator6(ID) -- ограниечение на добавление ID индикатора 6 которых нет в таблице Indicator6
ALTER TABLE COR ADD CONSTRAINT FK_COR_NumDS FOREIGN KEY (IDNumDS) REFERENCES NumDS(ID)  -- ограниечение на добавление ID ДС которых нет в таблице DS



