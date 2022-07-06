***

File Dataset (netflix_titles.csv) sẽ gồm các trường dữ liệu như sau:

show_id - INT: Id của bộ phim

type - VARCHAR(255): Thể loại của bộ phim đó

title - NVARCHAR(255): Tên phim

director - NVARCHAR(255): Đạo diễn

cast  - NVARCHAR(2000): Danh sách các diễn viên

country - VARCHAR(255): Nơi sản xuất

date_added - VARCHAR(255): Thời gian được thêm vào trên Netflix.

release_year  - VARCHAR(255): Năm công chiếu

rating - VARCHAR(255): Rating của khán giả

duration - VARCHAR(255): Thời lượng

listed_in - NVARCHAR(255): Danh mục

description - NVARCHAR(1000): Mô tả về phim


***

Hướng dẫn 

1. Import Dataset vào SQL Server

2. Tạo SSIS để làm ETL tải dữ liệu từ Data Source vào Data Warehouse.

3. Tạo ETL khác bằng T-SQL.

4. Tạo một Redshift Cluster để làm Cloud Data Warehouse

5. Sử dụng công cụ Amazon SCT để chuyển đổi Schema giữa SQL Server và Redshift

6. Di chuyển dữ liệu của On-premises Data Warehouse sang Cloud Data Warehouse

Sau khi dữ liệu đã được đưa từ Source vào On-Premises DW, bạn sẽ cần di chuyển các dữ liệu đó lên Redshift. Yêu cầu này sẽ gồm các bước như sau:

Bước 1: Export dữ liệu từ SQL Server dưới dạng file csv.

Bước 2: Upload các file csv đó lên S3 Bucket.

Bước 3: Sử dụng câu lệnh S3Copy để import dữ liệu từ S3 Bucket vào Redshift. Có thể dùng AWS Access Key và Secret Key hoặc gán 1 IAM role với các quyền đối với S3 cho RedShift.


Sau khi Import dữ liệu vào Redshift xong, bạn có thể sử dụng Data Grip connect tới Redshift và kiểm tra xem dữ liệu đã thực sự được import hay chưa.

7. Kiểm tra ETL có hoạt động đúng trên Redshift không

Khi di chuyển từ  On-premises Data Warehouse sang Cloud Data Warehouse, bạn cũng sẽ cần đảm bảo các ETL đã viết có thể hoạt động tốt trên môi trường Cloud. Bạn hãy thực hiện các bước sau để kiểm tra ETL:

Bước 1: Tạo một Database mới trên Redshift để làm Database Source, hoặc bạn có thể sử dụng SCT để convert Schema cho ASM3_Source.netflix_shows lên Redshift.

Bước 2: Import dữ liệu từ file "extra_data.csv" vào Source trên Redshift.

Bước 3: Chạy lại Procedure ETL đã di chuyển lên Redshift.

Bước 4: Kiểm tra xem dữ liệu từ Source đã được load lên Data Warehouse trên Redshift hay chưa. Nếu chưa được load thì tức là bạn chưa migrate ETL thành công.
