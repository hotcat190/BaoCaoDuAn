#heading(level: 1, numbering: none)[Chương 4: Cài đặt, triển khai và kiểm thử]

#counter(heading).update(4)

Mã nguồn của dự án được triển khai trên ba repo, tương ứng với ba thành phần chính của hệ thống:

#[
  #show link: set text(fill: blue)
  \- Frontend: https://github.com/longhoanglekim/my_reading_app
  
  \- Backend: https://github.com/huu24/comic-be
  
  \- AI Pipeline: https://github.com/hotcat190/manga-pipeline
]


== Môi trường phát triển và triển khai
Frontend được cài đặt để chạy trực tiếp trên máy cá nhân sử dụng môi trường NodeJS thông qua lệnh `npm run dev`.

Backend và AI Pipeline được cài đặt trên nền Docker, giúp đóng gói toàn bộ mã nguồn, môi trường cấu hình và các thư viện phụ thuộc thành các container độc lập, đảm bảo tính nhất quán tuyệt đối khi vận hành từ môi trường phát triển cục bộ đến môi trường triển khai thực tế.

Dự án sử dụng chức năng network của Docker:

#align(center)[`docker network create comic-network`]
#[#set par(first-line-indent: 0cm)
để tạo một bridge network, giúp các container ở hai repo có thể giao tiếp với nhau.
]
Các container của Backend:

\- `comic-backend`: Container Springboot chính cung cấp API cho Frontend và kết nối đến AI Pipeline và các service khác.

\- `comic_db`: Container chạy Database Postgres lưu dữ liệu các bảng của hệ thống.

\- `minio_storage`: Container MinIO để lưu ảnh và file JSON.

\- `comic_elasticsearch`: Container ElasticSearch phục vụ tìm kiếm truyện

\- `redis`: Container Redis để cache kết quả tìm kiếm truyện.

Các container của AI Pipeline:

\- `rabbitmq`: RabbitMQ message queue cho xử lý bất đồng bộ.

\- `manga-pipeline`: Container pipeline được bọc bởi FastApi và consumer để giao tiếp với RabbitMQ và Backend.

== Xây dựng Frontend



== Xây dựng Core Backend 



== Xây dựng AI Service
Cấu trúc thư mục của repo:

\- Root folder chứa các file `docker-compose.yml`, `Dockerfile`, `.env`, `requirements.txt` để setup.

\- `src`: lưu toàn bộ mã nguồn.

\- `tests`: lưu các script Python `test_pipeline.py` và `unit_tests`.

\- `models`: lưu các file model cần thiết `comictextdetector.pt`, `yolov12x_panels.pt`.

\- `comic_text_detector`: submodule `comic_text_detector` (lưu ý ký tự "\_").

AI Pipeline được xây dựng trên nguyên tắc OOP. Mô tả các file mã nguồn:

\- `src/api.py`: FastApi service, điểm khởi chạy của Pipeline.

\- `src/consumer.py`: Consumer xử lý message từ RabbitMQ và gửi response về Webhook Backend.

\- `src/main.py`: Định nghĩa Pipeline tổng.

\- `src/common`: Chứa các file `config.py`, `constants.py`, `utils.py` định nghĩa các lớp/hàm thông dụng; `som_drawer.py` định nghĩa hàm vẽ ảnh Set-of-Mark; các file `visual_debugger.py`, `position_debugger.py` phục vụ debug.

\- `src/engines`: file `base.py`, `factory.py` định nghĩa các lớp khởi tạo engine OCR giúp dễ mở rộng.

\- `src/engines/manga`: định nghĩa luồng OCR cho Manga, chứa các file `engine.py`, `panel_detector.py`, `bounding_box_sorter.py`, `text_processor.py`.

\- `src/engines/webtoon`: định nghĩa luồng OCR cho Webtoon trong file `webtoon_engine.py`.

\- `src/engines/ocr.py`: định nghĩa lớp OcrService, khởi tạo và quản lý các model `MangaOcr`, `PaddleOCR`.