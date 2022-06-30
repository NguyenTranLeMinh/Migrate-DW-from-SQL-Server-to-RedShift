Use ASM3_DW
go
create procedure LOAD_DIM_TYPE
as 
begin
	insert into ASM3_DW.dbo.DIM_TYPE(type)
	select distinct source.type
	from ASM3_Source.dbo.netflix_shows source
	where not exists (
		select 1
		from ASM3_DW.dbo.DIM_TYPE
		where source.type = ASM3_DW.dbo.DIM_TYPE.type
	)
end
go
--exec LOAD_DIM_TYPE
create procedure LOAD_DIM_COUNTRY
as
begin
	insert into ASM3_DW.dbo.DIM_COUNTRY(country)
	select distinct source.country
	from ASM3_Source.dbo.netflix_shows source
	where not exists (
		select 1
		from ASM3_DW.dbo.DIM_COUNTRY 
		where source.country = ASM3_DW.dbo.DIM_COUNTRY.country
	)
end
go
create procedure LOAD_DIM_DATE
as
begin
	insert into ASM3_DW.dbo.DIM_DATE(date_added, release_year)
	select distinct source.date_added, source.release_year
	from ASM3_Source..netflix_shows source
	where not exists (
		select 1
		from ASM3_DW..DIM_DATE t
		where source.date_added = t.date_added
			and source.release_year = t.release_year
	)
end
go
-- sad
create procedure LOAD_DIM_DIRECTOR
as
begin
	insert into ASM3_DW..DIM_DIRECTOR(director)
	select distinct source.director
	from ASM3_Source..netflix_shows source
	where not exists (
		select 1
		from ASM3_DW..DIM_DIRECTOR t
		where source.director = t.director
	)
end
go
create procedure LOAD_DIM_DURATION
as
begin
	insert into ASM3_DW..DIM_DURATION(duration)
	select distinct source.duration
	from ASM3_Source..netflix_shows source
	where not exists (
		select 1
		from ASM3_DW..DIM_DURATION t
		where source.duration = t.duration
	)
end
go
create procedure LOAD_DIM_INFO
as
begin
	insert into ASM3_DW..DIM_INFO(title, listed_in, description, cast)
	select distinct source.title, source.listed_in, source.description, source.cast
	from ASM3_Source..netflix_shows source
	where not exists (
		select 1
		from ASM3_DW..DIM_INFO t
		where source.title = t.title
			and source.listed_in = t.listed_in
			and source.description = t.description
			and source.cast = t.cast
	)
end
go
create procedure LOAD_DIM_RATING
as
begin
	insert into ASM3_DW..DIM_RATING(rating)
	select distinct source.rating
	from ASM3_Source..netflix_shows source
	where not exists (
		select 1
		from ASM3_DW..DIM_RATING t
		where source.rating = t.rating
	)
end
go

CREATE PROCEDURE LOAD_FACT_NETFLIX_SHOWS 
AS
BEGIN
	INSERT INTO ASM3_DW..FACT_NETFLIX_SHOWS(show_id, info_id, type_id, director_id, country_id, date_id, rating_id, duration_id) 
	SELECT show_id, info_id, type_id, director_id, country_id, date_id, rating_id, duration_id 
	FROM ASM3_Source..netflix_shows source 
	LEFT JOIN ASM3_DW..DIM_INFO dinfo ON dinfo.cast = source.cast 
		AND dinfo.description = source.description 
		AND dinfo.listed_in = source.listed_in 
		AND dinfo.title = source.title 
	LEFT JOIN ASM3_DW..DIM_TYPE dtype ON dtype.type = source.type 
	LEFT JOIN ASM3_DW..DIM_DIRECTOR dd ON dd.director = source.director 
	LEFT JOIN ASM3_DW..DIM_COUNTRY dc ON dc.country = source.country 
	LEFT JOIN ASM3_DW..DIM_DATE ddate ON ddate.date_added = source.date_added 
		AND ddate.release_year = source.release_year 
	LEFT JOIN ASM3_DW..DIM_RATING dra ON dra.rating = source.rating 
	LEFT JOIN ASM3_DW..DIM_DURATION dru ON dru.duration = source.duration 
END
GO 


-- Step 1
go
INSERT INTO ASM3_Source..tbDataLoaders (DateLog,DataLoader,StartDateTime)
VALUES (CONVERT(VARCHAR(12),GETDATE(),112),'EnergyDataLoaderOne Package',GETDATE())

exec LOAD_DIM_COUNTRY
exec LOAD_DIM_DATE
exec LOAD_DIM_DIRECTOR
exec LOAD_DIM_DURATION
exec LOAD_DIM_INFO
exec LOAD_DIM_RATING
exec LOAD_DIM_TYPE
exec LOAD_FACT_NETFLIX_SHOWS

-- Step 2
UPDATE ASM3_Source..tbDataLoaders
SET EndDateTime = GETDATE()
WHERE DateLog = CONVERT(VARCHAR(12),GETDATE(),112)
