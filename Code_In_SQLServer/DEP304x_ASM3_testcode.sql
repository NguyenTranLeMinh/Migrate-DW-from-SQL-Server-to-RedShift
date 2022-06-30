-- xoa DB
use master 
go
alter database [ASM3_DW] set single_user with rollback immediate
drop database [ASM3_DW]
go
alter database [ASM3_Source] set single_user with rollback immediate
drop database [ASM3_Source]
go
alter database [ASM3_StagingDB] set single_user with rollback immediate
drop database [ASM3_StagingDB]
go

GO
Truncate table [dbo].[netflix_shows_DEL]
Truncate table [dbo].[netflix_shows_INS]
Truncate table [dbo].[netflix_shows_UPD]
Truncate table [ASM3_Source].[dbo].[netflix_shows]
go
use ASM3_DW
go
Truncate table [dbo].[DIM_COUNTRY]
Truncate table [dbo].[DIM_DATE]
Truncate table [dbo].[DIM_DIRECTOR]
Truncate table [dbo].[DIM_DURATION]
Truncate table [dbo].[DIM_INFO]
Truncate table [dbo].[DIM_RATING]
Truncate table [dbo].[DIM_TYPE]
Truncate table [dbo].[FACT_NETFLIX_SHOWS]


-- kiem tra size cac cot
drop table if exists dbo.netflix_shows;
GO
create table dbo.netflix_shows
(
    show_id      INT NOT NULL PRIMARY KEY,
    type         NVARCHAR(max),
    title        NVARCHAR(max),
    director     NVARCHAR(max),
    cast         NVARCHAR(max),
    country      NVARCHAR(max),
    date_added   NVARCHAR(max),
    release_year INT,
    rating       NVARCHAR(max),
    duration     NVARCHAR(max),
    listed_in    NVARCHAR(max),
    description  NVARCHAR(max)
);
GO

select * from [ASM3_Source]..[netflix_shows]
Bulk insert ASM3_Source..netflix_shows
--FROM 'D:\Funix\DEP304x-01\ASM3_Tich_hop_MovieData_len_REDSHIFT\dataset\netflix_titles.csv'
FROM 'D:\Funix\DEP304x-01\ASM3_Tich_hop_MovieData_len_REDSHIFT\dataset\extra_data.csv'
with (
	FIRSTROW = 2, -- hang dau tien la header roi
	FIELDTERMINATOR = ',', -- dau phan cach giua cac cot
	ROWTERMINATOR = '0x0a', -- dau phan cach giua cac hang. Dung \n ko duoc. Link --https://stackoverflow.com/questions/7937581/issue-with-bulk-insert
	FIELDQUOTE = '"',
	TABLOCK
);
select * from [ASM3_Source]..[netflix_shows]

SELECT MAX(LEN(type)) as type,
    MAX(LEN(title)),
    MAX(LEN(director)),
    MAX(LEN(cast)) as cast,
    MAX(LEN(country)),
    MAX(LEN(date_added)),
    MAX(LEN(release_year)) as release_year,
    MAX(LEN(rating)),
	MAX(LEN(duration)),
	MAX(LEN(listed_in)) as listed_in,
	MAX(LEN(description))
From dbo.netflix_shows

-- runtime
use ASM3_Source
go
--truncate table [dbo].[tbDataLoaders]
select  top(1) *, datediff(ms, StartDateTime, EndDateTime) as 'runtime (ms)' from [dbo].[tbDataLoaders] order by StartDateTime desc


go 
-- kiem tra du lieu duoc insert
use ASM3_DW
go
Select * from [dbo].[DIM_COUNTRY]
Select * from [dbo].[DIM_DATE]
Select * from [dbo].[DIM_DIRECTOR]
Select * from [dbo].[DIM_DURATION]
Select * from [dbo].[DIM_INFO]
Select * from [dbo].[DIM_RATING]
Select * from [dbo].[DIM_TYPE]
Select * from ASM3_DW.[dbo].[FACT_NETFLIX_SHOWS]
go

select * from (select source.title, source.listed_in, source.description, source.cast
from ASM3_Source..netflix_shows source)
as a
except
select * from (select s.title, s.listed_in, s.description, s.cast
from ASM3_DW..DIM_INFO s)
as b