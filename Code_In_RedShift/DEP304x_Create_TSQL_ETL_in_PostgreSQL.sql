-- ------------ Write DROP-OTHER-stage scripts -----------

DROP PROCEDURE asm3_dw_dbo.load_dim_country(RetCode INOUT INTEGER);

DROP PROCEDURE asm3_dw_dbo.load_dim_date(RetCode INOUT INTEGER);

DROP PROCEDURE asm3_dw_dbo.load_dim_director(RetCode INOUT INTEGER);

DROP PROCEDURE asm3_dw_dbo.load_dim_duration(RetCode INOUT INTEGER);

DROP PROCEDURE asm3_dw_dbo.load_dim_info(RetCode INOUT INTEGER);

DROP PROCEDURE asm3_dw_dbo.load_dim_rating(RetCode INOUT INTEGER);

DROP PROCEDURE asm3_dw_dbo.load_dim_type(RetCode INOUT INTEGER);

DROP PROCEDURE asm3_dw_dbo.load_fact_netflix_shows(RetCode INOUT INTEGER);

-- ------------ Write CREATE-DATABASE-stage scripts -----------

CREATE SCHEMA IF NOT EXISTS asm3_dw_dbo;

-- ------------ Write CREATE-OTHER-stage scripts -----------

CREATE PROCEDURE asm3_dw_dbo.load_dim_country(RetCode INOUT INTEGER)
AS $BODY$
/* exec LOAD_DIM_TYPE */
BEGIN
    INSERT INTO asm3_dw_dbo.dim_country (country)
    SELECT DISTINCT
        source.country
        FROM asm3_source_dbo.netflix_shows AS source
        WHERE NOT EXISTS (SELECT
            1
            FROM asm3_dw_dbo.dim_country
            WHERE source.country = asm3_dw_dbo.dim_country.country);
    RetCode := 0;
    RETURN;
END;
$BODY$
LANGUAGE plpgsql;

CREATE PROCEDURE asm3_dw_dbo.load_dim_date(RetCode INOUT INTEGER)
AS $BODY$
BEGIN
    INSERT INTO asm3_dw_dbo.dim_date (date_added, release_year)
    SELECT DISTINCT
        source.date_added, source.release_year
        FROM asm3_source_dbo.netflix_shows AS source
        WHERE NOT EXISTS (SELECT
            1
            FROM asm3_dw_dbo.dim_date AS t
            WHERE source.date_added = t.date_added AND source.release_year = t.release_year);
    RetCode := 0;
    RETURN;
END;
$BODY$
LANGUAGE plpgsql;

CREATE PROCEDURE asm3_dw_dbo.load_dim_director(RetCode INOUT INTEGER)
AS $BODY$
/* sad */
BEGIN
    INSERT INTO asm3_dw_dbo.dim_director (director)
    SELECT DISTINCT
        source.director
        FROM asm3_source_dbo.netflix_shows AS source
        WHERE NOT EXISTS (SELECT
            1
            FROM asm3_dw_dbo.dim_director AS t
            WHERE source.director = t.director);
    RetCode := 0;
    RETURN;
END;
$BODY$
LANGUAGE plpgsql;

CREATE PROCEDURE asm3_dw_dbo.load_dim_duration(RetCode INOUT INTEGER)
AS $BODY$
BEGIN
    INSERT INTO asm3_dw_dbo.dim_duration (duration)
    SELECT DISTINCT
        source.duration
        FROM asm3_source_dbo.netflix_shows AS source
        WHERE NOT EXISTS (SELECT
            1
            FROM asm3_dw_dbo.dim_duration AS t
            WHERE source.duration = t.duration);
    RetCode := 0;
    RETURN;
END;
$BODY$
LANGUAGE plpgsql;

CREATE PROCEDURE asm3_dw_dbo.load_dim_info(RetCode INOUT INTEGER)
AS $BODY$
BEGIN
    INSERT INTO asm3_dw_dbo.dim_info (title, listed_in, description, "cast")
    SELECT DISTINCT
        source.title, source.listed_in, source.description, source."cast"
        FROM asm3_source_dbo.netflix_shows AS source
        WHERE NOT EXISTS (SELECT
            1
            FROM asm3_dw_dbo.dim_info AS t
            WHERE source.title = t.title AND source.listed_in = t.listed_in AND source.description = t.description AND source."cast" = t."cast");
    RetCode := 0;
    RETURN;
END;
$BODY$
LANGUAGE plpgsql;

CREATE PROCEDURE asm3_dw_dbo.load_dim_rating(RetCode INOUT INTEGER)
AS $BODY$
BEGIN
    INSERT INTO asm3_dw_dbo.dim_rating (rating)
    SELECT DISTINCT
        source.rating
        FROM asm3_source_dbo.netflix_shows AS source
        WHERE NOT EXISTS (SELECT
            1
            FROM asm3_dw_dbo.dim_rating AS t
            WHERE source.rating = t.rating);
    RetCode := 0;
    RETURN;
END;
$BODY$
LANGUAGE plpgsql;

CREATE PROCEDURE asm3_dw_dbo.load_dim_type(RetCode INOUT INTEGER)
AS $BODY$
BEGIN
    INSERT INTO asm3_dw_dbo.dim_type (type)
    SELECT DISTINCT
        source.type
        FROM asm3_source_dbo.netflix_shows AS source
        WHERE NOT EXISTS (SELECT
            1
            FROM asm3_dw_dbo.dim_type
            WHERE source.type = asm3_dw_dbo.dim_type.type);
    RetCode := 0;
    RETURN;
END;
$BODY$
LANGUAGE plpgsql;

CREATE PROCEDURE asm3_dw_dbo.load_fact_netflix_shows(RetCode INOUT INTEGER)
AS $BODY$
BEGIN
    INSERT INTO asm3_dw_dbo.fact_netflix_shows (show_id, info_id, type_id, director_id, country_id, date_id, rating_id, duration_id)
    SELECT
        show_id, info_id, type_id, director_id, country_id, date_id, rating_id, duration_id
        FROM asm3_source_dbo.netflix_shows AS source
        LEFT OUTER JOIN asm3_dw_dbo.dim_info AS dinfo
            ON dinfo."cast" = source."cast" AND dinfo.description = source.description AND dinfo.listed_in = source.listed_in AND dinfo.title = source.title
        LEFT OUTER JOIN asm3_dw_dbo.dim_type AS dtype
            ON dtype.type = source.type
        LEFT OUTER JOIN asm3_dw_dbo.dim_director AS dd
            ON dd.director = source.director
        LEFT OUTER JOIN asm3_dw_dbo.dim_country AS dc
            ON dc.country = source.country
        LEFT OUTER JOIN asm3_dw_dbo.dim_date AS ddate
            ON ddate.date_added = source.date_added AND ddate.release_year = source.release_year
        LEFT OUTER JOIN asm3_dw_dbo.dim_rating AS dra
            ON dra.rating = source.rating
        LEFT OUTER JOIN asm3_dw_dbo.dim_duration AS dru
            ON dru.duration = source.duration;
    RetCode := 0;
    RETURN;
END;
$BODY$
LANGUAGE plpgsql;

