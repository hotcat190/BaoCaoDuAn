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

=== Cấu trúc thư mục Frontend

\- `app`: Chứa toàn bộ mã nguồn các trang (pages), layouts và thành phần xử lý định tuyến (routing) của hệ thống.

\- `app/(auth)`: Chứa các luồng giao diện phục vụ việc xác thực gồm đăng nhập (`login`) và đăng ký (`signup`), có tích hợp các bộ custom hooks (`queryHook.ts`) và dịch vụ gọi API tương ứng (`service.ts`).

\- `app/(dashboard)`: Chứa các trang chức năng cốt lõi bao gồm trang cá nhân (`dashboard`), danh sách truyện (`books`), giao diện đọc truyện theo từng chương (`books/[id]/chapter/[chapter]`) cho người dùng; Giao diện đăng truyện (`publish`) và quản lý cập nhật chương mới (`manage`), quản lý người dùng cho admin (`admin/user-management`) .

\- `app/components`: Chứa các thành phần giao diện dùng chung có tính tái sử dụng cao như biểu mẫu (`CForm`), nút bấm (`CButton`), ô nhập liệu (`CInput`), thanh điều hướng (`Topbar`), thanh bên (`Sidebar`), hiển thị đánh giá (`BookRating`), hệ thống thông báo (`Notification`) và các bộ cấu hình trạng thái (`ThemeProvider`, `NotificationProvider`).

\- `app/config` & `app/const`: Chứa các tệp tin thiết lập cấu hình bảo mật xác thực (`auth.ts`) và định nghĩa phong cách thiết kế đồng bộ cho ứng dụng (`style.ts`).

\- `app/langs`: Chứa các file tài nguyên ngôn ngữ JSON (`en.json`, `vi.json`) để phục vụ tính năng chuyển đổi đa ngôn ngữ Anh - Việt.

\- `app/store`: Quản lý và duy trì trạng thái toàn cục cho phiên làm việc của người dùng bằng thư viện Zustand thông qua tệp `userStore.ts`.

=== Các công nghệ và thư viện nền tảng được áp dụng

\- `Next.js 16` & `React 19`: Framework và thư viện giao diện cốt lõi hỗ trợ cơ chế render phía máy chủ (SSR) và tối ưu hóa hiệu năng ứng dụng.

\- `@tanstack/react-query` & `axios`: Bộ đôi quản lý việc gửi yêu cầu HTTP, đồng bộ hóa và lưu bộ nhớ đệm (caching) dữ liệu từ phía Core Backend.

\- `Zustand`: Thư viện quản lý trạng thái (state management) tối giản, chịu trách nhiệm duy trì thông tin định danh và quyền hạn của người dùng toàn cục.

\- `Tailwind CSS v4`: Framework CSS tiện ích giúp xây dựng giao diện phản hồi nhanh chóng (responsive) và đồng bộ hóa chế độ hiển thị sáng/tối (Dark/Light mode).

\- `React Hook Form`: Thư viện tối ưu hóa hiệu năng xử lý và kiểm soát tính hợp lệ dữ liệu biểu mẫu (form validation) cho các chức năng đăng ký, đăng nhập và đăng tải nội dung truyện.

\- `React Intl`: Thư viện hỗ trợ quốc tế hóa và bản địa hóa giao diện đọc truyện một cách toàn diện.

== Xây dựng Core Backend 

=== Cấu trúc tổ chức mã nguồn của Core Backend

\- `config`: Chứa các lớp thiết lập cấu hình tích hợp hệ thống bao gồm Redis Cache, Elasticsearch, hàng đợi RabbitMQ và dịch vụ lưu trữ đối tượng MinIO.

\- `controller`: Tiếp nhận các yêu cầu HTTP bên ngoài và định nghĩa RESTful API phục vụ các luồng chức năng xác thực, tương tác dữ liệu truyện, quản lý danh mục, thư viện, lịch sử đọc và tiếp nhận kết quả xử lý từ AI Webhook.

\- `model`: Định nghĩa cấu trúc các thực thể quan hệ (Entities) đồng bộ với PostgreSQL và các tài liệu chỉ mục (Documents) ánh xạ lên cụm tìm kiếm Elasticsearch.

\- `repository`: Thực hiện trừu tượng hóa tầng truy cập dữ liệu (Data Access Layer) bằng cách sử dụng Spring Data JPA và Spring Data Elasticsearch Repositories.

\- `service`: Chức năng xử lý toàn bộ logic nghiệp vụ cốt lõi bao gồm điều phối luồng dữ liệu truyện, kiểm soát tệp tin đa phương tiện, lọc ngôn từ thô tục và đẩy tin nhắn tác vụ bất đồng bộ vào hàng đợi.

\- `security`: Thiết lập bộ lọc bảo mật hệ thống dựa trên Spring Security, sử dụng cơ chế JWT thông qua HTTP-Only Secure Cookie và phân quyền truy cập dựa trên vai trò người dùng (RBAC).

=== Các công nghệ và thư viện nền tảng được áp dụng

\- `Spring Security, JWT & OAuth2`: Cung cấp giải pháp bảo mật toàn diện cho hệ thống API, quản lý phiên làm việc an toàn và tích hợp các phương thức đăng nhập bên thứ ba.

\- `Spring Data JPA & PostgreSQL`: Hệ quản trị cơ sở dữ liệu nền tảng chịu trách nhiệm lưu trữ cấu trúc dữ liệu quan hệ đồng bộ như thông tin tài khoản, danh mục, bình luận, lịch sử đọc truyện.

\- `spring-boot-starter-data-elasticsearch`: Thư viện cung cấp khả năng tích hợp Spring Data với công cụ tìm kiếm Elasticsearch, hỗ trợ lập chỉ mục chuyên biệt và tối ưu hóa hiệu năng tra cứu toàn văn (Full-text search) trên dữ liệu truyện với độ trễ thấp.

\- `spring-boot-starter-data-redis` & `spring-boot-starter-cache`: Bộ thư viện quản lý bộ nhớ đệm (caching), phối hợp cùng thư viện `caffeine` để triển khai giải pháp lưu trữ tạm thời các kết quả API phổ biến, giúp tăng tốc độ phản hồi hệ thống và giảm tải các truy vấn lặp lại trực tiếp tới cơ sở dữ liệu.

\- `spring-boot-starter-amqp`: Thư viện hiện thực hóa giao thức AMQP hỗ trợ tích hợp với hệ thống hàng đợi tin nhắn RabbitMQ, đóng vai trò truyền tải và điều phối các thông điệp tác vụ xử lý ảnh bất đồng bộ từ Backend sang AI Pipeline mà không gây tắc nghẽn hệ thống.

\- `MinIO Java SDK`: Giải pháp lưu trữ đối tượng tương thích chuẩn S3, đóng vai trò quản lý tập trung và bảo mật toàn bộ tệp tin hình ảnh trang truyện gốc cùng dữ liệu JSON kết quả dịch thuật tách biệt.

== Xây dựng AI Service
=== Cấu trúc thư mục của AI Pipeline

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

=== Các công nghệ học sâu và thư viện cốt lõi được áp dụng trong AI Pipeline

\- `FastAPI` & `uvicorn`: Framework và Web Server hiệu năng cao hỗ trợ xây dựng các API endpoint bất đồng bộ, tối ưu hóa tốc độ tiếp nhận yêu cầu xử lý từ hệ thống và tiếp nhận dữ liệu tải lên thông qua thư viện `python-multipart`.

\- `google-genai` & `Pydantic`: Sử dụng SDK thế hệ mới để kết nối với mô hình ngôn ngữ lớn Gemini (`genai.Client`), cho phép truyền tải đồng thời cả ảnh Set-of-Mark (`som_image`) và văn bản nhằm tiến hành dịch thuật hàng loạt (Batch Translation) bám sát ngữ cảnh; kết hợp tính năng Structured Outputs của Gemini để ép kiểu dữ liệu trả về dạng JSON có cấu trúc chặt chẽ dựa trên lược đồ Pydantic (`BatchTranslationResult`).

\- `aio-pika` & `httpx`: Bộ đôi thư viện lập trình bất đồng bộ đảm nhận vai trò lắng nghe cấu hình tác vụ từ hàng đợi RabbitMQ thông qua thành phần Consumer, đồng thời gửi các yêu cầu HTTP Callback thông báo trạng thái tiến trình xử lý sang Webhook Backend.

\- Thư viện OCR (`manga-ocr`, `paddleocr` & `ultralytics`): Tập hợp các công cụ và framework học sâu phục vụ luồng nhận diện, trong đó áp dụng mô hình YOLO để nhận diện phân tách các khung tranh (Panel Detection) và sử dụng kiến trúc OCR chuyên dụng nhằm trích xuất văn bản đa ngôn ngữ từ bong bóng thoại.

\- `simple-lama-inpainting` & `opencv-python`: Giải pháp xử lý hình ảnh nâng cao, chịu trách nhiệm xóa và lấp đầy vùng văn bản gốc (Inpainting) dựa trên mặt nạ nhị phân, tái tạo lại nền tranh gốc một cách tự nhiên trước khi đưa qua tầng chèn chữ văn bản dịch.

\- Thư viện `minio`: Công cụ kết nối lưu trữ đối tượng chuẩn S3, cụ thể hóa qua lớp dịch vụ `MinioStorageService` để đồng bộ tải lên các tệp tin hình ảnh sau khi tẩy chữ (`upload_image`) và xuất bản các tệp tin dữ liệu văn bản dịch thuật định dạng JSON (`upload_json`) lên bộ lưu trữ tập trung.

== Kiểm thử hệ thống
Công tác kiểm thử được thực hiện toàn diện trên cả ba thành phần nhằm đảm bảo tính ổn định, độ tin cậy của mã nguồn và độ chính xác của các thuật toán học sâu.

=== Kiểm thử tĩnh thành phần Frontend
Đối với thành phần Frontend, hệ thống tập trung vào việc kiểm soát và chuẩn hóa chất lượng mã nguồn ngay từ giai đoạn phát triển.

\- Sử dụng công cụ `ESLint` phối hợp với hệ thống kiểm tra kiểu dữ liệu nghiêm ngặt của ngôn ngữ TypeScript để thực hiện phân tích mã nguồn tĩnh, giúp phát hiện sớm các lỗi cú pháp, biến chưa sử dụng và áp dụng nhất quán quy chuẩn thiết kế trong các component React.

=== Kiểm thử thành phần Core Backend
Tầng Core Backend ứng dụng quy trình kiểm thử nghiêm ngặt kết hợp giữa kiểm thử đơn vị, kiểm thử tích hợp và kiểm thử đột biến nhằm kiểm soát tối đa chất lượng hệ thống.

\- Sử dụng framework JUnit 5 kết hợp với Mockito và Spring Boot Test để xây dựng các kịch bản kiểm thử tự động, đồng thời sử dụng cơ sở dữ liệu nhúng H2 làm môi trường lưu trữ cô lập phục vụ riêng cho quá trình chạy thử nghiệm.

\- Kiểm thử tầng Controller: Áp dụng cấu hình `@WebMvcTest` nhằm giả lập các yêu cầu HTTP để kiểm tra toàn diện các endpoint REST API, tính đúng đắn của định dạng dữ liệu phản hồi, mã trạng thái và cơ chế kiểm soát quyền hạn.

\- Kiểm thử tầng Service: Tập trung xác thực logic nghiệp vụ cốt lõi bằng cách cô lập hoàn toàn các dependency thông qua Mockito Mock, bảo đảm các chức năng lọc từ ngữ thô tục, điều phối tiến trình và dịch vụ lưu trữ đối tượng hoạt động chính xác.

\- Đo lường độ bao phủ mã nguồn: Sử dụng plugin `jacoco-maven-plugin` để tự động hóa việc thu thập chỉ số độ bao phủ, cấu hình loại trừ các thư mục không chứa logic phức tạp như DTO, Entity hay các lớp Exception để phản ánh chính xác hiệu quả kiểm thử.

\- Kiểm thử đột biến (Mutation Testing): Tích hợp plugin `pitest-maven` nhằm đánh giá năng lực của chính bộ test case tại tầng Service và Security bằng cách tự động tạo ra các lỗi nhân tạo (mutations) trong mã nguồn gốc để đo lường tỷ lệ phát hiện lỗi.

Ngoài ra khi triển khai Core Backend trực tiếp lên Docker, nhóm sử dụng công cụ Postman @postman để gửi request trực tiếp đến các Endpoint để kiểm tra luồng khi chạy thật.

=== Kiểm thử thành phần AI Pipeline

==== Mô tả chung
Thành phần AI Pipeline tập trung vào việc kiểm thử độ chính xác của thuật toán xử lý hình học không gian và tính toàn vẹn của luồng xử lý ảnh.

\- Sử dụng framework `pytest` làm nền tảng chính giúp tự động hóa toàn bộ quá trình thực thi các kịch bản kiểm thử mã nguồn Python.

\- Kiểm thử đơn vị (Unit Test): Triển khai các bộ dữ liệu kiểm thử chuyên biệt cho các module hình học của bộ sắp xếp khung tranh (`panel_sorter`), bao gồm thuật toán xác định khoảng cách giữa các khung truyện (`test_find_gutters`), thuật toán kiểm tra tính bao hàm giữa các bounding box (`test_is_contained`) và kiểm thử thứ tự đọc.

\- Kiểm thử tích hợp (Integration Test): Sử dụng script `test_pipeline.py` nhằm mô phỏng và đánh giá tính toàn vẹn của toàn bộ chuỗi tiến trình xử lý, bắt đầu từ khâu nhận dạng khung hình, trích xuất OCR, xóa chữ nền (Inpainting) cho đến giai đoạn chuyển ngữ.

==== Mô tả script `test_pipeline.py`

Script `test_pipeline.py` được xây dựng dưới dạng một Command Line Utility hỗ trợ kiểm thử tích hợp cục bộ độc lập mà không cần phụ thuộc vào hạ tầng hàng đợi tin nhắn RabbitMQ. Script này cung cấp các tham số cấu hình linh hoạt để vận hành thử nghiệm:

\- `--image`: Xác định chính xác tên tệp tin hình ảnh trang truyện mẫu nằm trong thư mục tài nguyên `tests/assets/` dùng làm dữ liệu đầu vào.

\- `--source-lang`: Thiết lập mã ngôn ngữ gốc của trang truyện đầu vào (mặc định là ngôn ngữ tiếng Nhật `ja`).

\- `--target-langs`: Tiếp nhận danh sách các mã ngôn ngữ đích cần phân dịch, phân tách nhau bằng dấu cách (mặc định thực hiện dịch song song ra cả tiếng Anh `en` và tiếng Việt `vi`).

\- `--comic-type`: Định nghĩa định dạng bố cục truyện để kích hoạt luồng xử lý tương ứng bao gồm chế độ đọc truyền thống `manga` hoặc định dạng cuộn dọc `webtoon`.

\- `--no-translate`: Tham số tùy chọn (flag) cho phép hệ thống bỏ qua tầng dịch thuật ngữ cảnh bằng mô hình ngôn ngữ lớn, giúp cô lập để kiểm tra chuyên biệt hiệu năng của phân hệ phát hiện khung, OCR văn bản và xóa chữ nền Inpainting.

Khi thực thi, công cụ tiến hành nạp biến môi trường từ tệp `.env`, xác thực sự tồn tại của khóa cấu hình `GEMINI_API_KEY` và đóng gói các tham số thành một cấu trúc tác vụ mẫu (`test_job`). Script sẽ khởi tạo thực thể `MangaPipeline` kết hợp cùng lớp dịch vụ `LocalStorageService` để xử lý và tự động kết xuất toàn bộ hình ảnh đã làm sạch cùng file cấu trúc metadata JSON vào thư mục phân tách theo mốc thời gian bên trong phân hệ `local_output`, đồng thời in toàn bộ cấu trúc JSON kết quả ra màn hình terminal.

==== Các công cụ Debug 
Do phải làm việc với dữ liệu ảnh, việc kiểm tra độ chính xác đầu ra của các mô hình nhận diện và các thuật toán sắp xếp dưới dạng text là tương đối khó khăn. Vì vậy, pipeline sử dụng các Utility `VisualDebugger` và `PositionDebugger` để sinh ảnh đầu ra trực quan trong từng giai đoạn:

\- `VisualDebugger`: Xuất phản hồi trực quan bằng cách vẽ trực tiếp các khung bao (bounding boxes), nhãn phân loại khung tranh (panels), khối văn bản (text blocks) và khung bao có hướng (OBB) lên hình ảnh thông qua thư viện OpenCV, giúp người phát triển dễ dàng kiểm tra trực quan kết quả của từng giai đoạn trung gian.

\- `PositionDebugger`: Tập trung vào việc bảo toàn tính toàn vẹn dữ liệu hình học bằng cách trích xuất và lưu trữ chi tiết các thông tin tọa độ ra các tệp tin định dạng JSON, đồng bộ hóa theo các cấu trúc chuẩn hóa như `[x, y, w, h]` hoặc danh sách điểm đa giác để phục vụ các phân hệ xử lý luồng đọc ở hạ nguồn.

Cả hai lớp tiện ích gỡ lỗi này đều được kiểm soát chặt chẽ thông qua việc thiết lập biến môi trường `DEBUG_VISUALIZE`. Cơ chế này đảm bảo các tác vụ ghi tệp và kết xuất đồ họa chỉ được kích hoạt trong môi trường phát triển/thử nghiệm, đồng thời hoàn toàn bị vô hiệu hóa khi hệ thống vận hành trên môi trường triển khai thực tế nhằm tối ưu hóa hiệu năng và tốc độ xử lý của pipeline.
#v(12pt)
#figure(
  image("/images/pipeline_text_blocks.png"),
  caption: [Ví dụ ảnh debug text blocks, Arisa © Yagami Ken]
)

#heading(numbering: none, outlined: true)[Demo]
#counter("is-chương").update(0)

Demo của dự án được trình bày trong video sau:

TBA
