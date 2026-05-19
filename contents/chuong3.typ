#heading(level: 1, numbering: none)[Chương 3: Thiết kế Kiến trúc và Hệ thống]

#counter(heading).update(3)

== Kiến trúc tổng thể hệ thống

Hệ thống được thiết kế dựa trên mô hình Kiến trúc Hướng dịch vụ Lai (Hybrid Service-Oriented Architecture - SOA). Kiến trúc này phân tách hệ thống thành hai khối chính: khối xử lý nghiệp vụ cốt lõi (Core Business) và khối xử lý tác vụ trí tuệ nhân tạo (AI Pipeline). Các khối dịch vụ giao tiếp với nhau theo cơ chế bất đồng bộ thông qua Message Broker, nhằm tối ưu hóa tài nguyên tính toán, giải quyết vấn đề thắt nút cổ chai (bottleneck) trong các tác vụ xử lý hình ảnh và ngôn ngữ tự nhiên có độ trễ cao. Tổng thể hệ thống được phân tầng thành 4 lớp vật lý và logic:

=== Tầng Giao diện

Được triển khai bằng framework Next.js, tầng này chịu trách nhiệm xử lý giao diện người dùng và tương tác hệ thống. 

\- Chức năng đối với người dùng cuối: Cung cấp giao diện đọc truyện (Comic Viewer), thu thập sự kiện tương tác chạm, tính toán định vị tọa độ $(x, y)$ của đối tượng khung thoại trên hình ảnh để kích hoạt tính năng dịch thuật (Tap-to-Translate).

\- Chức năng đối với quản trị viên: Cung cấp giao diện quản trị (Dashboard) thực hiện thao tác tải lên dữ liệu, quản lý siêu dữ liệu (metadata) và giám sát trạng thái của luồng xử lý AI.

=== Tầng Dịch vụ Cốt lõi

Được xây dựng trên nền tảng Java Spring Boot, khối dịch vụ này đóng vai trò điều phối luồng dữ liệu trung tâm và cung cấp các RESTful API. Tầng này bao gồm các module thành phần:

\- Module Security, Auth: Xử lý quy trình xác thực thông qua JSON Web Token (JWT) và thiết lập phân quyền truy cập dựa trên vai trò (Role-Based Access Control).

\- Module Content Management: Quản lý tính toàn vẹn của siêu dữ liệu truyện tranh, thông tin tác giả, phân loại thể loại và đồng bộ trạng thái đọc của người dùng.

\- Module Search Engine Controller: Điều phối luồng đồng bộ hóa dữ liệu từ cơ sở dữ liệu quan hệ sang hệ thống tìm kiếm, tiếp nhận và xử lý các truy vấn tìm kiếm đa điều kiện.

\- Module Task Coordinator: Quản lý quy trình tải lên tệp tin. Khi tiếp nhận dữ liệu ảnh mới, module thực hiện lưu trữ sơ bộ vào Object Storage và định tuyến thông điệp chứa siêu dữ liệu vào Message Queue để tiến hành chuyển giao cho tầng AI xử lý bất đồng bộ.

=== Tầng Dịch vụ AI

Bao gồm các dịch vụ AI Worker được triển khai bằng framework FastAPI (Python), chuyên biệt hóa cho việc vận hành các mô hình Machine Learning. Tầng này thiết lập giao tiếp với Core Backend thông qua RabbitMQ. Quy trình xử lý tuần tự bao gồm:

\- Khởi tạo tiến trình lắng nghe các sự kiện nhận diện chương truyện mới từ Message Queue.

\- Thực thi pipeline xử lý dữ liệu đa phương tiện: Trích xuất văn bản từ hình ảnh (OCR) $->$ Dịch thuật văn bản dựa trên ngữ cảnh sử dụng LLM $->$ Tái tạo nền ảnh và loại bỏ văn bản gốc (Inpainting).

\- Kết xuất dữ liệu đầu ra bao gồm định dạng JSON chứa tọa độ đối tượng văn bản và các tệp hình ảnh đã qua xử lý.

=== Tầng Dữ liệu và Lưu trữ

Hệ thống triển khai phương pháp Polyglot Persistence để đáp ứng các yêu cầu đặc thù về lưu trữ và hiệu suất truy xuất dữ liệu:

\- PostgreSQL: Cơ sở dữ liệu quan hệ chính, đảm bảo tuân thủ tiêu chuẩn ACID đối với dữ liệu định danh người dùng, danh mục truyện và bản ghi lịch sử tương tác.

\- Elasticsearch: Hệ quản trị cơ sở dữ liệu tìm kiếm toàn văn bản (Full-text search) dựa trên cấu trúc chỉ mục đảo ngược (Inverted Index), hỗ trợ xử lý truy vấn tìm kiếm mờ (Fuzzy search) với độ trễ thấp.

\- Redis: Hệ thống lưu trữ dữ liệu dạng Key-Value trên bộ nhớ trong (In-memory Cache), đóng vai trò bộ nhớ đệm giảm tải cho cơ sở dữ liệu chính thông qua việc lưu trữ các kết quả truy vấn có tần suất truy cập cao.

\- MinIO: Dịch vụ lưu trữ đối tượng (Object Storage) tương thích chuẩn S3 API, cung cấp giải pháp lưu trữ cho các tệp nhị phân kích thước lớn bao gồm hình ảnh trang truyện gốc (Raw images) và hình ảnh sau xử lý AI (Inpainted images).

// #figure(
//   image("images/architecture_diagram.png", width: 90%),
//   caption: [Sơ đồ Kiến trúc tổng thể hệ thống (Hybrid SOA)],
// ) <fig-architecture>

== Thiết kế Cơ sở dữ liệu

Hệ thống sử dụng hệ quản trị cơ sở dữ liệu quan hệ PostgreSQL để lưu trữ dữ liệu cấu trúc có tính toàn vẹn cao, thực thi các ràng buộc dữ liệu và phục vụ các tác vụ truy vấn nghiệp vụ cốt lõi.

=== Biểu đồ Thực thể Liên kết (ERD)

Mô hình dữ liệu logic của hệ thống được biểu diễn thông qua cấu trúc thực thể liên kết, xác định rõ các thực thể chính và các mối quan hệ ràng buộc giữa chúng trong hệ thống quản lý truyện tranh tích hợp xử lý dịch thuật.

// #figure(
//   image("images/erd_diagram.png", width: 85%),
//   caption: [Biểu đồ thực thể liên kết (ERD) của hệ thống],
// ) <fig-erd>

Các mối quan hệ logic giữa các thực thể trong hệ thống được quy định cụ thể:

\- Một bản ghi trong bảng truyện tranh (Comics) liên kết với nhiều bản ghi trong bảng chương truyện (Chapters), thiết lập mối quan hệ một - nhiều (1 - N).

\- Một bản ghi trong bảng người dùng (Users) liên kết với nhiều bản ghi trong bảng lịch sử (History) để lưu trữ tiến trình tương tác dữ liệu, thiết lập mối quan hệ một - nhiều (1 - N).

\- Một bản ghi trong bảng chương truyện (Chapters) liên kết với nhiều bản ghi trong bảng lịch sử (History), thiết lập mối quan hệ một - nhiều (1 - N).

=== Mô tả các bảng dữ liệu chính

Hệ thống thiết lập cấu trúc chi tiết cho các bảng dữ liệu thành phần trong PostgreSQL nhằm đảm bảo tối ưu hóa kiểu dữ liệu và không gian lưu trữ ổ đĩa.

==== Bảng Users (Quản lý người dùng)

Bảng users thực hiện chức năng lưu trữ thông tin định danh cá nhân, dữ liệu xác thực và hệ thống theo dõi hạn mức sử dụng các dịch vụ trí tuệ nhân tạo (AI) của từng tài khoản.

#figure(
  table(
    columns: (1.5fr, auto, 1fr, 2.5fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Ràng buộc*], [*Mô tả*]),
    [id], [BIGINT], [PRIMARY KEY], [Khóa chính, định danh tự động tăng (IDENTITY)],
    [auth_provider], [VARCHAR(255)], [], [Nền tảng cung cấp dịch vụ xác thực (Local/OAuth2)],
    [avatar_url], [VARCHAR(255)], [], [Đường dẫn liên kết đến tệp tin ảnh đại diện],
    [created_at], [TIMESTAMPTZ], [], [Thời điểm bản ghi được khởi tạo],
    [daily_ai_usage], [INTEGER], [], [Số lượng truy vấn dịch vụ AI đã thực thi trong ngày],
    [email], [VARCHAR(255)], [UNIQUE], [Địa chỉ thư điện tử của người dùng],
    [full_name], [VARCHAR(255)], [], [Họ và tên đầy đủ của người dùng],
    [last_ai_usage_date], [DATE], [], [Ngày hệ thống ghi nhận tương tác AI gần nhất],
    [password_hash], [VARCHAR(255)], [], [Chuỗi dữ liệu mật khẩu đã qua thuật toán băm (hashing)],
    [role], [VARCHAR(255)], [], [Vai trò phân quyền truy cập hệ thống],
    [status], [VARCHAR(255)], [], [Trạng thái hoạt động hiện tại của tài khoản],
    [updated_at], [TIMESTAMPTZ], [], [Thời điểm bản ghi được cập nhật thay đổi gần nhất]
  ),
  caption: [Cấu trúc dữ liệu chi tiết của bảng users],
) <table-users>

==== Bảng Comics (Quản lý thông tin tác phẩm)

Bảng comics thực hiện chức năng lưu trữ thông tin siêu dữ liệu (metadata) của các tác phẩm truyện tranh, bao gồm các thuộc tính định dạng, ngôn ngữ gốc và số liệu thống kê đánh giá từ người dùng.

#figure(
  table(
    columns: (auto, auto, 1.2fr, 2.5fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Ràng buộc*], [*Mô tả*]),
    [id], [BIGINT], [PRIMARY KEY], [Khóa chính, định danh tự động tăng (IDENTITY)],
    [author], [VARCHAR(255)], [], [Tên định danh của tác giả tác phẩm],
    [average_rating], [DOUBLE PRECISION], [], [Điểm đánh giá trung bình hệ thống ghi nhận đối với tác phẩm],
    [cover_image_url], [VARCHAR(255)], [], [Đường dẫn liên kết đến tệp tin ảnh bìa lưu trữ tại hệ thống ngoài],
    [created_at], [TIMESTAMPTZ], [], [Thời điểm bản ghi thông tin tác phẩm được khởi tạo],
    [description], [TEXT], [], [Nội dung văn bản tóm tắt chi tiết của tác phẩm],
    [format], [VARCHAR(255)], [], [Định dạng hiển thị của tác phẩm (ví dụ: Manga, Webtoon)],
    [original_language], [VARCHAR(255)], [], [Ngôn ngữ văn bản gốc của tác phẩm],
    [status], [VARCHAR(255)], [], [Trạng thái phát hành hiện tại của tác phẩm truyện tranh],
    [title], [VARCHAR(255)], [], [Tiêu đề định danh chính của tác phẩm],
    [total_ratings], [INTEGER], [], [Tổng số lượng lượt đánh giá tác phẩm từ người dùng],
    [updated_at], [TIMESTAMPTZ], [], [Thời điểm bản ghi thông tin tác phẩm được cập nhật gần nhất]
  ),
  caption: [Cấu trúc dữ liệu chi tiết của bảng comics],
) <table-comics>

==== Bảng Chapters (Quản lý chương truyện)

Bảng chapters thực hiện chức năng lưu trữ dữ liệu phân mảnh nội dung của các tác phẩm truyện tranh theo từng chương, đồng thời thiết lập ràng buộc tham chiếu logic trực tiếp đến bảng comics.

#figure(
  table(
    columns: (auto, auto, auto, 2.5fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Ràng buộc*], [*Mô tả*]),
    [id], [BIGINT], [PRIMARY KEY], [Khóa chính, định danh tự động tăng (IDENTITY)],
    [chapter_number], [INTEGER], [], [Chỉ số thứ tự phân bổ của chương truyện],
    [comic_id], [BIGINT], [FOREIGN KEY], [Khóa ngoại định danh tham chiếu đến bảng comics],
    [created_at], [TIMESTAMPTZ], [], [Thời điểm bản ghi dữ liệu chương được khởi tạo],
    [title], [VARCHAR(255)], [], [Tiêu đề định danh văn bản cụ thể của chương truyện]
  ),
  caption: [Cấu trúc dữ liệu chi tiết của bảng chapters],
) <table-chapters>

==== Bảng Pages (Quản lý trang truyện)

Bảng pages thực hiện chức năng lưu trữ thông tin phân mảnh ở cấp độ trang truyện vật lý, bao gồm dữ liệu hình ảnh nguyên bản, dữ liệu hình ảnh sau xử lý và siêu dữ liệu (metadata) hỗ trợ hệ thống nhận diện tọa độ văn bản.

#figure(
  table(
    columns: (auto, auto, 1fr, 2.5fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Ràng buộc*], [*Mô tả*]),
    [id], [BIGINT], [PRIMARY KEY], [Khóa chính, định danh tự động tăng (IDENTITY)],
    [chapter_id], [BIGINT], [FOREIGN KEY], [Khóa ngoại định danh tham chiếu đến bảng chapters],
    [cleaned_image_url], [VARCHAR(255)], [], [Đường dẫn liên kết đến tệp tin hình ảnh đã qua xử lý loại bỏ văn bản (inpainting)],
    [created_at], [TIMESTAMPTZ], [], [Thời điểm bản ghi dữ liệu trang truyện được khởi tạo],
    [image_url], [VARCHAR(255)], [], [Đường dẫn liên kết đến tệp tin hình ảnh nguyên bản gốc],
    [original_metadata_url], [VARCHAR(255)], [], [Đường dẫn liên kết đến tệp tin JSON chứa siêu dữ liệu tọa độ văn bản (OCR)],
    [page_number], [INTEGER], [], [Chỉ số thứ tự phân bổ của trang truyện trong phạm vi một chương]
  ),
  caption: [Cấu trúc dữ liệu chi tiết của bảng pages],
) <table-pages>

==== Bảng Reading Histories (Quản lý lịch sử đọc)

Bảng reading_histories thực hiện chức năng ghi vết trạng thái tương tác và định vị trang đọc cuối cùng của người dùng đối với từng tác phẩm truyện tranh cụ thể. Thiết kế của bảng áp dụng cấu trúc khóa chính tổ hợp (Composite Primary Key) nhằm tối ưu hóa hiệu suất truy vấn trong logic nghiệp vụ cá nhân hóa tiến trình đọc.

#figure(
  table(
    columns: (auto, auto, 1.6fr, 2.5fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Ràng buộc*], [*Mô tả*]),
    [comic_id], [BIGINT], [PRIMARY KEY, FOREIGN KEY], [Khóa chính tổ hợp, khóa ngoại tham chiếu đến bảng comics],
    [user_id], [BIGINT], [PRIMARY KEY, FOREIGN KEY], [Khóa chính tổ hợp, khóa ngoại tham chiếu đến bảng users],
    [chapter_id], [BIGINT], [FOREIGN KEY], [Khóa ngoại tham chiếu đến bảng chapters chứa trang đang đọc],
    [last_page_read], [INTEGER], [], [Chỉ số thứ tự trang cuối cùng hệ thống ghi nhận người dùng đã truy cập],
    [updated_at], [TIMESTAMPTZ], [], [Thời điểm bản ghi tiến trình đọc được cập nhật gần nhất]
  ),
  caption: [Cấu trúc dữ liệu chi tiết của bảng reading_histories],
) <table-reading-histories>

==== Bảng Page Translations (Quản lý dữ liệu dịch thuật)

Bảng page_translations thực hiện chức năng lưu trữ tham chiếu đến các tệp tin siêu dữ liệu (metadata) chứa nội dung đã được hệ thống trí tuệ nhân tạo (AI) dịch thuật, phân loại theo từng ngôn ngữ đích cụ thể cho mỗi trang truyện. Cấu trúc thiết kế áp dụng ràng buộc duy nhất tổ hợp (Composite Unique Constraint) giữa mã ngôn ngữ và định danh trang nhằm ngăn chặn hiện tượng trùng lặp dữ liệu dịch thuật.

#figure(
  table(
    columns: (auto, auto, 1.5fr, 2.5fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Ràng buộc*], [*Mô tả*]),
    [id], [BIGINT], [PRIMARY KEY], [Khóa chính, định danh tự động tăng (IDENTITY)],
    [lang], [VARCHAR(10)], [UNIQUE], [Mã định danh quy ước chuẩn của ngôn ngữ đích (ví dụ: vi, en, ja)],
    [page_id], [BIGINT], [FOREIGN KEY, UNIQUE], [Khóa ngoại tham chiếu đến bảng pages. Cùng với trường lang thiết lập ràng buộc duy nhất],
    [translation_metadata_url], [VARCHAR(255)], [], [Đường dẫn liên kết đến tệp tin JSON lưu trữ siêu dữ liệu văn bản đã dịch thuật]
  ),
  caption: [Cấu trúc dữ liệu chi tiết của bảng page_translations],
) <table-page-translations>

== Thiết kế luồng xử lý AI

== Thiết kế luồng giao tiếp Client - AI

== Thiết kế giao diện người dùng