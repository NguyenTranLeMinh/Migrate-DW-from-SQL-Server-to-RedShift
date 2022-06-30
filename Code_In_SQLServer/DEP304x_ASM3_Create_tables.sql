create database ASM3_Source;
GO
use ASM3_Source;
GO
drop table if exists dbo.netflix_shows;
GO
create table dbo.netflix_shows
(
    show_id      INT NOT NULL PRIMARY KEY,
    type         NVARCHAR(50),
    title        NVARCHAR(200),
    director     NVARCHAR(500),
    cast         NVARCHAR(1000),
    country      NVARCHAR(200),
    date_added   NVARCHAR(50),
    release_year INT,
    rating       NVARCHAR(50),
    duration     NVARCHAR(50),
    listed_in    NVARCHAR(200),
    description  NVARCHAR(1000)
);
GO
Bulk insert dbo.netflix_shows
FROM 'D:\Funix\DEP304x-01\ASM3_Tich_hop_MovieData_len_REDSHIFT\dataset\netflix_titles.csv'
with (
	FIRSTROW = 2, -- hang dau tien la header roi
	FIELDTERMINATOR = ',', -- dau phan cach giua cac cot
	ROWTERMINATOR = '0x0a', -- dau phan cach giua cac hang. Dung \n ko duoc. Link --https://stackoverflow.com/questions/7937581/issue-with-bulk-insert
	FIELDQUOTE = '"',
	TABLOCK
);
-- Bang nay kiem tra thoi gian chay
CREATE TABLE tbDataLoaders(
 DateLog VARCHAR(12),
 DataLoader VARCHAR(100),
 StartDateTime DATETIME,
 EndDateTime DATETIME
)
--NEXT
GO
create database ASM3_DW;
GO
use ASM3_DW
GO
CREATE TABLE [dbo].[DIM_COUNTRY](
	[country_id] [int] identity(1,1) NOT NULL PRIMARY KEY,
	[country] [NVARCHAR](200) NULL,
)
GO
CREATE TABLE [dbo].[DIM_DIRECTOR](
	[director_id] [int] identity(1,1) NOT NULL PRIMARY KEY,
	[director] [NVARCHAR](500) NULL,
)
GO
CREATE TABLE [dbo].[DIM_DATE](
	[date_id] [int] identity(1,1) NOT NULL PRIMARY KEY,
	[date_added] [NVARCHAR](50) NULL,
	[release_year] [int] NULL,
)
GO
CREATE TABLE [dbo].[DIM_RATING](
	[rating_id] [int] identity(1,1) NOT NULL PRIMARY KEY,
	[rating] [NVARCHAR](50) NULL,
)
GO
CREATE TABLE [dbo].[DIM_DURATION](
	[duration_id] [int] identity(1,1) NOT NULL PRIMARY KEY,
	[duration] [NVARCHAR](50) NULL,
)
GO
CREATE TABLE [dbo].[DIM_INFO](
	[info_id] [int] identity(1,1) NOT NULL PRIMARY KEY,
	[title] [NVARCHAR](200) NULL,
	[listed_in] [NVARCHAR](200) NULL,
	[description] [NVARCHAR](1000) NULL,
	[cast] [NVARCHAR](1000) NULL,
)
GO
CREATE TABLE [dbo].[DIM_TYPE](
	[type_id] [int] identity(1,1) NOT NULL PRIMARY KEY,
	[type] [NVARCHAR](50) NULL,
)
GO
CREATE TABLE [dbo].[FACT_NETFLIX_SHOWS](
	[show_id] [int] NOT NULL PRIMARY KEY,
	[info_id] [int] FOREIGN KEY REFERENCES DIM_INFO(info_id),
	[type_id] [int] FOREIGN KEY REFERENCES DIM_TYPE(type_id),
	[director_id] [int] FOREIGN KEY REFERENCES DIM_DIRECTOR(director_id),
	[country_id] [int] FOREIGN KEY REFERENCES DIM_COUNTRY(country_id),
	[date_id] [int] FOREIGN KEY REFERENCES DIM_DATE(date_id),
	[rating_id] [int] FOREIGN KEY REFERENCES DIM_RATING(rating_id),
	[duration_id] [int] FOREIGN KEY REFERENCES DIM_DURATION(duration_id),
)

