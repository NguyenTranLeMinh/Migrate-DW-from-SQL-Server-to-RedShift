COPY asm3_dw_dbo.dim_country(country_id, country)
from 's3://dep304x-asm3/asm3/DIM_COUNTRY.csv'
iam_role 'arn:aws:iam::520103763238:role/S3_access_from_Redshift'
CSV
EXPLICIT_IDS
ignoreheader 1;

COPY asm3_dw_dbo.dim_date(date_id, date_added, release_year)
from 's3://dep304x-asm3/asm3/DIM_DATE.csv'
iam_role 'arn:aws:iam::520103763238:role/S3_access_from_Redshift'
CSV
EXPLICIT_IDS
ignoreheader 1;

COPY asm3_dw_dbo.dim_director(director_id, director)
from 's3://dep304x-asm3/asm3/DIM_DIRECTOR.csv'
iam_role 'arn:aws:iam::520103763238:role/S3_access_from_Redshift'
CSV
EXPLICIT_IDS
ignoreheader 1;

COPY asm3_dw_dbo.dim_duration(duration_id, duration)
from 's3://dep304x-asm3/asm3/DIM_DURATION.csv'
iam_role 'arn:aws:iam::520103763238:role/S3_access_from_Redshift'
CSV
EXPLICIT_IDS
ignoreheader 1;

COPY asm3_dw_dbo.dim_info(info_id, title, listed_in, description, "cast")
from 's3://dep304x-asm3/asm3/DIM_INFO.csv'
iam_role 'arn:aws:iam::520103763238:role/S3_access_from_Redshift'
CSV
EXPLICIT_IDS
ignoreheader 1;

COPY asm3_dw_dbo.dim_rating(rating_id, rating)
from 's3://dep304x-asm3/asm3/DIM_RATING.csv'
iam_role 'arn:aws:iam::520103763238:role/S3_access_from_Redshift'
CSV
EXPLICIT_IDS
ignoreheader 1;

COPY asm3_dw_dbo.dim_type(type_id, type)
from 's3://dep304x-asm3/asm3/DIM_TYPE.csv'
iam_role 'arn:aws:iam::520103763238:role/S3_access_from_Redshift'
CSV
EXPLICIT_IDS
ignoreheader 1;

COPY asm3_dw_dbo.fact_netflix_shows(show_id, info_id, type_id, director_id, country_id, date_id, rating_id, duration_id)
from 's3://dep304x-asm3/asm3/FACT_NETFLIX_SHOWS.csv'
iam_role 'arn:aws:iam::520103763238:role/S3_access_from_Redshift'
CSV
ignoreheader 1;