select * from information_schema.routines where routine_type = 'PROCEDURE'
;
select count(*) from asm3_source_dbo.netflix_shows;
select count(*) from asm3_dw_dbo.dim_country;
--
truncate table asm3_dw_dbo.dim_country;
truncate table asm3_dw_dbo.dim_date;
truncate table asm3_dw_dbo.dim_director;
truncate table asm3_dw_dbo.dim_duration;
truncate table asm3_dw_dbo.dim_info;
truncate table asm3_dw_dbo.dim_rating;
truncate table asm3_dw_dbo.dim_type;
truncate table asm3_dw_dbo.fact_netflix_shows;

truncate table asm3_source_dbo.netflix_shows;
;
--

call asm3_dw_dbo.load_dim_country(1);
call asm3_dw_dbo.load_dim_date(1);
call asm3_dw_dbo.load_dim_director(1);
call asm3_dw_dbo.load_dim_duration(1);
call asm3_dw_dbo.load_dim_info(1);
call asm3_dw_dbo.load_dim_rating(1);
call asm3_dw_dbo.load_dim_type(1);
call asm3_dw_dbo.load_fact_netflix_shows(1);

