#heading(level: 1, numbering: none)[Chương 3: Thiết kế kiến trúc và hệ thống]

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

#figure(
  image("../images/Architecture-2026-05-20-180834.png"),
  caption: [Sơ đồ kiến trúc tổng thể hệ thống],
) <fig-architecture>

== Thiết kế Cơ sở dữ liệu

Hệ thống sử dụng hệ quản trị cơ sở dữ liệu quan hệ PostgreSQL để lưu trữ dữ liệu cấu trúc có tính toàn vẹn cao, thực thi các ràng buộc dữ liệu và phục vụ các tác vụ truy vấn nghiệp vụ cốt lõi.

=== Biểu đồ thực thể liên kết (ERD)

Mô hình dữ liệu logic của hệ thống được biểu diễn thông qua cấu trúc thực thể liên kết, xác định rõ các thực thể chính và các mối quan hệ ràng buộc giữa chúng trong hệ thống quản lý truyện tranh tích hợp xử lý dịch thuật.

#figure(
  image("../images/ERD_2026-05-20-181355.png"),
  caption: [Biểu đồ thực thể liên kết],
) <fig-erd>
#v(12pt)
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

==== Bảng Categories (Quản lý danh mục truyện)

Bảng categories thực hiện chức năng lưu trữ danh mục các thể loại truyện tranh phục vụ cho việc phân nhóm, thiết lập bộ lọc nâng cao và tối ưu hóa luồng tìm kiếm phân loại của người dùng.

#figure(
  table(
    columns: (1.5fr, auto, 1.2fr, 2.5fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Ràng buộc*], [*Mô tả*]),
    [id], [BIGINT], [PRIMARY KEY], [Khóa chính, định danh tự động tăng (IDENTITY)],
    [name], [VARCHAR(255)], [UNIQUE, NOT NULL], [Tên định danh duy nhất của danh mục hoặc thể loại truyện tranh]
  ),
  caption: [Cấu trúc dữ liệu chi tiết của bảng categories],
) <table-categories>

==== Bảng Comic Categories (Liên kết truyện và danh mục)

Bảng comic_categories đóng vai trò là bảng trung gian để thể hiện mối quan hệ nhiều - nhiều (N - N) giữa tác phẩm truyện tranh (comics) và danh mục thể loại (categories), sử dụng cấu trúc khóa chính tổ hợp để tối ưu hiệu năng truy vấn.

#figure(
  table(
    columns: (1.5fr, auto, 1.5fr, 2.5fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Ràng buộc*], [*Mô tả*]),
    [comic_id], [BIGINT], [PRIMARY KEY, FOREIGN KEY], [Khóa chính tổ hợp, khóa ngoại tham chiếu đến định danh id của bảng comics],
    [category_id], [BIGINT], [PRIMARY KEY, FOREIGN KEY], [Khóa chính tổ hợp, khóa ngoại tham chiếu đến định danh id của bảng categories]
  ),
  caption: [Cấu trúc dữ liệu chi tiết của bảng comic_categories],
) <table-comic-categories>

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

==== Bảng User Libraries (Quản lý tủ sách cá nhân)

Bảng user_libraries chịu trách nhiệm lưu trữ danh sách các tác phẩm truyện tranh được người dùng lưu trữ trong tủ sách cá nhân, đồng thời phân loại theo từng mục đích hoặc phân hệ theo dõi cụ thể.

#figure(
  table(
    columns: (auto, auto, 1.5fr, 2.5fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Ràng buộc*], [*Mô tả*]),
    [user_id], [BIGINT], [PRIMARY KEY, FOREIGN KEY, NOT NULL], [Khóa chính tổ hợp, khóa ngoại tham chiếu đến định danh id của bảng users],
    [comic_id], [BIGINT], [PRIMARY KEY, FOREIGN KEY, NOT NULL], [Khóa chính tổ hợp, khóa ngoại tham chiếu đến định danh id của bảng comics],
    [list_type], [VARCHAR(255)], [NOT NULL], [Loại danh mục lưu trữ trong thư viện (định dạng chuỗi ký tự ánh xạ từ Enum)],
    [created_at], [TIMESTAMPTZ], [NOT NULL], [Thời điểm người dùng thực hiện lưu tác phẩm vào thư viện cá nhân]
  ),
  caption: [Cấu trúc dữ liệu chi tiết của bảng user_libraries],
) <table-user-libraries>

==== Bảng Ratings (Quản lý điểm số đánh giá)

Bảng ratings thực hiện chức năng ghi nhận điểm số đánh giá trực quan của từng tài khoản người dùng đối với các tác phẩm truyện tranh trên hệ thống, phục vụ cho việc tính toán phân tích điểm trung bình tổng quan.

#figure(
  table(
    columns: (auto, auto, 1.5fr, 2.5fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Ràng buộc*], [*Mô tả*]),
    [user_id], [BIGINT], [PRIMARY KEY, FOREIGN KEY, NOT NULL], [Khóa chính tổ hợp, khóa ngoại tham chiếu đến định danh id của bảng users],
    [comic_id], [BIGINT], [PRIMARY KEY, FOREIGN KEY, NOT NULL], [Khóa chính tổ hợp, khóa ngoại tham chiếu đến định danh id của bảng comics],
    [score], [INTEGER], [NOT NULL], [Điểm số đánh giá chất lượng tác phẩm do độc giả thiết lập],
    [created_at], [TIMESTAMPTZ], [NOT NULL], [Thời điểm bản ghi đánh giá được hệ thống khởi tạo]
  ),
  caption: [Cấu trúc dữ liệu chi tiết của bảng ratings],
) <table-ratings>

==== Bảng Comments (Quản lý bình luận chương truyện)

Bảng comments chịu trách nhiệm quản lý toàn bộ nội dung tương tác thảo luận, nhận xét và phản hồi từ phía độc giả tại khu vực không gian bên dưới mỗi chương truyện cụ thể.

#figure(
  table(
    columns: (auto, auto, 1.5fr, 2.5fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Ràng buộc*], [*Mô tả*]),
    [id], [BIGINT], [PRIMARY KEY], [Khóa chính, định danh tự động tăng (IDENTITY)],
    [chapter_id], [BIGINT], [FOREIGN KEY, NOT NULL], [Khóa ngoại tham chiếu trực tiếp đến định danh id của bảng chapters],
    [user_id], [BIGINT], [FOREIGN KEY, NOT NULL], [Khóa ngoại tham chiếu trực tiếp đến định danh id của bảng users],
    [content], [VARCHAR(1000)], [NOT NULL], [Nội dung văn bản bình luận hoặc ý kiến phản hồi của độc giả],
    [parent_id], [BIGINT], [FOREIGN KEY], [Khóa ngoại tự tham chiếu đến bình luận cha nhằm xây dựng cấu trúc phân nhánh cây (Threaded Comments)],
    [created_at], [TIMESTAMPTZ], [NOT NULL], [Thời điểm bản ghi thảo luận được khởi tạo],
    [updated_at], [TIMESTAMPTZ], [NOT NULL], [Thời điểm bản ghi thảo luận được cập nhật hoặc sửa đổi gần nhất]
  ),
  caption: [Cấu trúc dữ liệu chi tiết của bảng comments],
) <table-comments>

==== Bảng Email Verification Otps (Quản lý mã xác thực OTP)

Bảng email_verification_otps thực hiện chức năng lưu trữ và kiểm soát chu kỳ sống ngắn hạn của các mã số OTP ngẫu nhiên được gửi qua hòm thư điện tử để phục vụ khâu xác minh định danh tài khoản an toàn.

#figure(
  table(
    columns: (auto, auto, 1.5fr, 2.5fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Ràng buộc*], [*Mô tả*]),
    [id], [BIGINT], [PRIMARY KEY], [Khóa chính, định danh tự động tăng (IDENTITY)],
    [email], [VARCHAR(255)], [UNIQUE, NOT NULL], [Địa chỉ thư điện tử duy nhất đăng ký tiếp nhận mã xác thực OTP],
    [otp], [VARCHAR(6)], [NOT NULL], [Chuỗi mã số OTP xác thực bao gồm đúng 6 ký tự],
    [expires_at], [TIMESTAMPTZ], [NOT NULL], [Thời điểm giới hạn mã OTP chính thức hết hiệu lực sử dụng],
    [created_at], [TIMESTAMPTZ], [NOT NULL], [Thời điểm hệ thống khởi tạo mã OTP gửi đi],
    [updated_at], [TIMESTAMPTZ], [NOT NULL], [Thời điểm bản ghi được cập nhật trạng thái đồng bộ gần nhất]
  ),
  caption: [Cấu trúc dữ liệu chi tiết của bảng email_verification_otps],
) <table-email-verification-otps>

#show figure: set block(breakable: true)

== Thiết kế API

Mục này xác định chi tiết các API và quy chuẩn cấu trúc dữ liệu trao đổi giữa bốn thành phần cốt lõi trong hệ thống: Next.js Client, Spring Boot Backend, hệ thống hàng chờ thông điệp RabbitMQ và AI Worker Pipeline (FastAPI). Việc chuẩn hóa cấu trúc dữ liệu tại các điểm giao tiếp này bảo đảm tính toàn vẹn dữ liệu, khả năng co giãn độc lập của các dịch vụ và là cơ sở kỹ thuật để xây dựng các biểu đồ tuần tự (Sequence Diagrams) cho hệ thống.

=== Các giao diện REST API của hệ thống Core Backend

Hệ thống Core Backend (Spring Boot) vận hành cấu trúc HTTP RESTful API tập trung, đóng vai trò đầu mối tiếp nhận điều phối luồng dữ liệu toàn cục. Giao tiếp mạng được phân chia rõ ràng thành hai vùng phân cấp bảo mật dựa trên cơ chế phân quyền vai trò (RBAC).

==== Nhóm API nghiệp vụ dành cho Client (Public & Authenticated API)

Nhóm giao diện lập trình này cung cấp các cổng kết nối cho Next.js Client để thực thi các tác vụ công khai (duyệt tìm truyện, xem danh mục) và các tác vụ yêu cầu xác thực định danh qua mã thông báo JWT (bình luận, đánh giá độ rating, đồng bộ lịch sử và tủ sách cá nhân).

#figure(
  table(
    columns: (auto, 1.5fr, auto, 2.5fr),
    table.header([*Phương thức*], [*Endpoint*], [*Xác thực*], [*Mô tả chức năng nghiệp vụ*]),
    [GET], [/auth/me], [JWT / Không], [Kiểm tra trạng thái phiên làm việc và trích xuất hồ sơ cá nhân hiện tại],
    [POST], [/auth/register], [Không], [Đăng ký tài khoản thành viên mới trực tiếp vào hệ thống],
    [POST], [/auth/register-otp], [Không], [Khởi tạo tiến trình đăng ký và gửi mã OTP xác thực qua email],
    [POST], [/auth/verify-email-otp], [Không], [Xác thực mã OTP để kích hoạt tài khoản thành viên chính thức],
    [POST], [/auth/resend-email-otp], [Không], [Yêu cầu hệ thống tạo và gửi lại mã OTP xác thực mới],
    [POST], [/auth/login], [Không], [Xác thực tài khoản và cấp mã thông báo quyền truy cập hệ thống],
    [POST], [/auth/logout], [JWT], [Hủy bỏ trạng thái phiên làm việc và xóa cookie xác thực an toàn],
    [GET], [/oauth2/providers], [Không], [Lấy danh sách cấu hình các nền tảng ủy quyền bên thứ ba],
    [GET], [/categories], [Không], [Duyệt toàn bộ danh sách danh mục thể loại truyện tranh hiện có],
    [GET], [/comics], [Không], [Duyệt danh sách tác phẩm theo từ khóa, thể loại và ngôn ngữ gốc],
    [GET], [/comics/search], [Không], [Truy vấn tìm kiếm nhanh danh sách truyện qua chỉ mục Elasticsearch],
    [GET], [/comics/search/detail], [Không], [Truy vấn tìm kiếm chi tiết phân trang qua Elasticsearch],
    [GET], [/comics/by-genre], [Không], [Lấy danh sách các tác phẩm được phân cụm cấu trúc theo thể loại],
    [GET], [/comics/genres], [Không], [Truy xuất danh sách thể loại dưới dạng danh mục thực thể gốc],
    [GET], [/comics/{#text(style: "italic")[id]}], [Không], [Tải toàn bộ thông tin chi tiết của một tác phẩm truyện tranh],
    [GET], [/comics/{#text(style: "italic")[id]}/chapters], [Không], [Lấy danh sách phân trang các chương thuộc tác phẩm chỉ định],
    [GET], [/comics/{#text(style: "italic")[id]}/book-overview], [Không], [Tải siêu dữ liệu tổng quan cấu trúc chương của tác phẩm],
    [GET], [/comics/{#text(style: "italic")[id]}/chapter/{#text(style: "italic")[num]}], [Không], [Tải thông tin tổng quan của một số thứ tự chương cụ thể],
    [PUT], [/comics/{#text(style: "italic")[id]}/ratings], [JWT], [Gửi điểm số đánh giá chất lượng tác phẩm từ người dùng],
    [GET], [/chapters/{#text(style: "italic")[id]}/pages], [Không], [Tải danh sách cấu trúc các trang ảnh phục vụ trình xem truyện],
    [GET], [/chapters/{#text(style: "italic")[id]}/comments], [Không], [Tải danh sách các bản ghi bình luận phân trang dưới chương],
    [POST], [/chapters/{#text(style: "italic")[id]}/comments], [JWT], [Khởi tạo bản ghi bình luận hoặc phản hồi mới dưới chương],
    [GET], [/pages/{#text(style: "italic")[id]}], [Không], [Tải thông tin trang, gồm tệp ảnh inpainting và siêu dữ liệu dịch],
    [GET], [/reading-histories/comics/{#text(style: "italic")[id]}], [JWT], [Truy xuất tiến độ trang đọc cuối cùng được ghi nhận của truyện],
    [PUT], [/reading-histories], [JWT], [Đồng bộ tiến trình đọc thời gian thực về máy chủ trung tâm],
    [GET], [/user-libraries], [JWT], [Tải danh sách các tác phẩm trong tủ sách cá nhân theo bộ lọc],
    [POST], [/user-libraries], [JWT], [Thêm mới hoặc cập nhật phân loại truyện vào tủ sách cá nhân],
    [DELETE], [/user-libraries/comics/{#text(style: "italic")[id]}], [JWT], [Xóa liên kết tác phẩm khỏi tủ sách cá nhân]
  ),
  caption: [Danh mục các giao diện REST API dành cho giao diện Client],
) <table-client-api>

==== Nhóm API quản trị và tích hợp nội bộ (Admin & Internal Webhook API)

Phân hệ này cô lập các cổng lập trình có đặc quyền cao dành riêng cho Quản trị viên để thực hiện thay đổi cấu trúc dữ liệu truyện, tải lên chương mới và cung cấp cổng Webhook (`/api/internal/webhook/**`) để tiếp nhận phản hồi bất đồng bộ từ các AI Worker Worker.

#figure(
  table(
    columns: (auto, 1.5fr, auto, 2.5fr),
    table.header([*Phương thức*], [*Endpoint*], [*Xác thực*], [*Mô tả chức năng nghiệp vụ*]),
    [GET], [/admin/users], [Admin JWT], [Quản lý và tìm kiếm danh sách người dùng trên toàn hệ thống],
    [PATCH], [/admin/users/{#text(style: "italic")[id]}/status], [Admin JWT], [Thay đổi trạng thái hoạt động (khóa/mở khóa) của tài khoản],
    [PATCH], [/admin/users/{#text(style: "italic")[id]}/role], [Admin JWT], [Hiệu chỉnh quyền hạn vai trò truy cập của người dùng],
    [GET], [/admin/dashboard/summary], [Admin JWT], [Truy xuất số liệu thống kê tổng quan của toàn bộ hệ thống],
    [POST], [/categories], [Admin JWT], [Thêm mới một danh mục thể loại truyện tranh vào hệ thống],
    [PUT], [/categories/{#text(style: "italic")[id]}], [Admin JWT], [Cập nhật thông tin định danh của danh mục thể loại hiện có],
    [DELETE], [/categories/{#text(style: "italic")[id]}], [Admin JWT], [Xóa bỏ hoàn toàn thực thể thể loại khỏi cơ sở dữ liệu],
    [POST], [/comics], [Admin JWT], [Khởi tạo tác phẩm mới kèm tải lên tệp tin hình ảnh bìa gốc],
    [DELETE], [/comics/{#text(style: "italic")[id]}], [Admin JWT], [Xóa bỏ toàn bộ dữ liệu cấu trúc và tệp tin của một tác phẩm],
    [POST], [/comics/{#text(style: "italic")[id]}/chapters], [Admin JWT], [Khởi tạo một thực thể chương mới thuộc tác phẩm chỉ định],
    [POST], [/chapters/{#text(style: "italic")[id]}/pages], [Admin JWT], [Tải lên tập hợp ảnh thô và kích hoạt AI Pipeline xử lý],
    [DELETE], [/chapters/pages/{#text(style: "italic")[id]}], [Admin JWT], [Xóa bỏ một bản ghi trang truyện vật lý đơn lẻ khỏi hệ thống],
    [DELETE], [/chapters/{#text(style: "italic")[id]}/pages], [Admin JWT], [Xóa toàn bộ các cấu trúc trang ảnh thuộc về một chương],
    [POST], [/comics/reindex], [Admin JWT], [Kích hoạt tiến trình đồng bộ tái lập chỉ mục lên Elasticsearch],
    [POST], [/api/internal/webhook/processing-result], [Internal], [Tiếp nhận gói payload kết quả xử lý đồ họa từ AI Worker]
  ),
  caption: [Danh mục các giao diện API quản trị và webhook nội bộ],
) <table-admin-internal-api>



=== Đặc tả cấu trúc tệp siêu dữ liệu phân tách (Metadata Schemas)

Để tối ưu hóa hạ tầng lưu trữ và băng thông truyền tải, hệ thống không nhúng trực tiếp văn bản dịch vào các điểm ảnh của tệp đồ họa. Thay vào đó, cấu trúc hình học và thông tin ngôn ngữ được tách biệt hoàn toàn thành các tệp siêu dữ liệu định dạng JSON lưu trữ độc lập trên Object Storage.



==== Tệp siêu dữ liệu tọa độ gốc (original_metadata)

Tệp dữ liệu này lưu trữ cấu trúc hình học pixel và kết quả nhận diện văn bản thô (OCR) của tất cả các bong bóng thoại phát hiện trên một trang truyện.
#[
  #show figure: set block(breakable: false)
  #figure(
    ```json
    {
      "page_id": "string",
      "bubbles": [
        {
          "id": 1,
          "box": [0, 0, 0, 0],
          "original_text": "string",
          "chunks": [
            {
              "chunk_id": "string",
              "word": "string",
              "romanization": "string"
            }
          ]
        }
      ]
    }
    ```,
    kind: "code-snippet",
    supplement: [Đoạn mã],
    caption: [Cấu trúc JSON của original_metadata],
  )
]
#v(12pt)

#figure(
  table(
    columns: (1.8fr, 1.2fr, 3fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Mô tả*]),
    [`page_id`], [String], [Mã định danh duy nhất của trang truyện.],
    [`bubbles`], [Array (Object)], [Danh sách các khối bong bóng thoại phát hiện trên trang.],
    [`bubbles[].` \u{200b} `id`], [Integer], [Mã định danh cục bộ của bong bóng thoại trong trang.],
    [`bubbles[].` \u{200b} `box`], [Array (Integer)], [Tọa độ vùng bao [x, y, width, height] của hộp chữ (tính theo pixel).],
    [`bubbles[].` \u{200b} `original_text`], [String], [Văn bản gốc trích xuất từ mô hình OCR.],
    [`bubbles[].` \u{200b} `chunks`], [Array (Object)], [Mảng phân tách văn bản thô thành từ hoặc cụm từ để tính toán va chạm tương tác.],
    [`bubbles[].` \u{200b} `chunks[].` \u{200b} `chunk_id`], [String], [Mã phân đoạn từ (ví dụ: "1-1") làm cơ sở đối chiếu bản dịch.],
    [`bubbles[].` \u{200b} `chunks[].` \u{200b} `word`], [String], [Từ hoặc cụm từ thô tương ứng.],
    [`bubbles[].` \u{200b} `chunks[].` \u{200b} `romanization`], [String], [Phiên âm hệ chữ Latinh của từ gốc.]
  ),
  caption: [Đặc tả chi tiết các trường dữ liệu của cấu trúc original_metadata],
) <table-original-metadata-fields>

#v(12pt)
Quy chuẩn hình học và logic ràng buộc của cấu trúc `original_metadata` được quy định như sau:

\- Trường `bubbles[].box` chứa chính xác 4 giá trị số nguyên lớn hơn hoặc bằng 0, đại diện lần lượt cho tọa độ điểm pixel góc trên bên trái trục hoành (x), trục tung (y), độ rộng vật lý (width) và chiều cao vật lý (height) của khung thoại.

\- Hệ thống Client sử dụng các thông số trong mảng `box` phối hợp với kích thước thực tế của khung hiển thị để tính toán tỷ lệ co giãn (Scaling factor) nhằm tái định vị lớp chữ động đè khít lên vị trí tranh thô.

==== Tệp siêu dữ liệu dịch thuật (translation_metadata)

Tệp dữ liệu này lưu trữ kết quả biên dịch ngữ cảnh được xử lý bởi mô hình ngôn ngữ lớn (LLM), ánh xạ đồng bộ với tệp tọa độ gốc thông qua các mã liên kết cấu trúc.

#[
  #show figure: set block(breakable: false)
  #figure(
    ```json
    {
      "page_id": "string",
      "bubbles": [
        {
          "id": 1,
          "full_translation": "string",
          "chunk_meanings": [
            {
              "chunk_id": "string",
              "type": "string",
              "meaning": "string"
            }
          ]
        }
      ]
    }
    ```,
    kind: "code-snippet",
    supplement: [Đoạn mã],
    caption: [Cấu trúc JSON của translation_metadata]
  )
]
#v(12pt)

#figure(
  table(
    columns: (1.8fr, 1.2fr, 3fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Mô tả*]),
    [`page_id`], [String], [Mã định danh trang truyện (trùng khớp với tệp tọa độ gốc).],
    [`bubbles`], [Array (Object)], [Danh sách bản dịch và dữ liệu ngữ nghĩa theo ngôn ngữ mục tiêu.],
    [`bubbles[].` \u{200b} `id`], [Integer], [Mã định danh bong bóng thoại (khớp với tệp gốc để xác định vị trí render).],
    [`bubbles[].` \u{200b} `full_translation`], [String], [Nội dung văn bản dịch hoàn chỉnh sang ngôn ngữ đích.],
    [`bubbles[].` \u{200b} `chunk_meanings`], [Array (Object)], [Mảng dữ liệu giải nghĩa chi tiết từng từ phục vụ tính năng Tap-to-Translate.],
    [`bubbles[].` \u{200b} `chunk_meanings[].` \u{200b} `chunk_id`], [String], [Mã định danh phân đoạn từ (khớp nối trực tiếp với chunk_id ở tệp gốc).],
    [`bubbles[].` \u{200b} `chunk_meanings[].` \u{200b} `type`], [String], [Phân loại từ loại hoặc thuộc tính ngữ pháp (ví dụ: từ tượng thanh, danh từ).],
    [`bubbles[].` \u{200b} `chunk_meanings[].` \u{200b} `meaning`], [String], [Nội dung giải nghĩa chi tiết của từ dựa trên ngữ cảnh phân đoạn truyện.]
  ),
  caption: [Đặc tả chi tiết các trường dữ liệu của cấu trúc translation_metadata],
) <table-translation-metadata-fields>

#v(12pt)
Logic liên kết và phân tích tương tác của tệp dịch thuật:

\- Trường `bubbles[].id` bắt buộc phải trùng khớp tuyệt đối với `id` của tệp dữ liệu gốc để Client đồng bộ chính xác nội dung dịch đè lên ảnh nền sạch.

\- Mảng `chunk_meanings` cung cấp dữ liệu giải nghĩa chi tiết cho từng phân đoạn từ, phục vụ thuật toán kiểm tra va chạm hình học (Collision Detection) dựa trên tọa độ điểm chạm để hiển thị cửa sổ pop-up tra cứu thời gian thực.

=== Đặc tả cấu trúc thông điệp hàng chờ (Message Queue Job Payload)

Tiến trình chuyển giao tác vụ từ Core Backend (Java) sang AI Worker (Python) được thực hiện bất đồng bộ bằng cách đẩy một thông điệp (Payload) định dạng JSON Object vào hàng chờ bền vững `manga-queue` của RabbitMQ. Cấu trúc này đóng vai trò là một hợp đồng dữ liệu giữa dịch vụ gửi (Producer) và dịch vụ nhận (Consumer).

#[
  #show figure: set block(breakable: false)
  #figure(
    ```json
    {
      "job_id": "string",
      "chapter_id": "string",
      "page_id": "string",
      "image_url": "string",
      "source_lang": "string",
      "target_langs": ["string"],
      "comic_type": "string",
      "skip_translate": false,
      "webhook_url": "string"
    }
    ```,
    kind: "code-snippet",
    supplement: [Đoạn mã],
    caption: [Cấu trúc JSON Payload của thông điệp PipelineJobRequest],
  )
]
#v(12pt)

#figure(
  table(
    columns: (1.8fr, 1.2fr, 3fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Mô tả*]),
    [`job_id`], [String], [Mã định danh duy nhất của tác vụ xử lý.],
    [`chapter_id`], [String], [Mã định danh chương truyện chứa trang ảnh.],
    [`page_id`], [String], [Mã định danh trang truyện vật lý cần xử lý.],
    [`image_url`], [String], [Đường dẫn URL của tệp ảnh gốc trên MinIO Object Storage.],
    [`source_lang`], [String], [Mã ngôn ngữ gốc của tác phẩm (ví dụ: ko, ja, zh).],
    [`target_langs`], [Array (String)], [Danh sách các mã ngôn ngữ đích cần hệ thống dịch thuật.],
    [`comic_type`], [String], [Định dạng cấu trúc truyện tranh (Manga hoặc Webtoon).],
    [`skip_translate`], [Boolean], [Cờ cấu hình cho phép bỏ qua bước dịch thuật ngữ cảnh.],
    [`webhook_url`], [String], [Địa chỉ cổng callback Webhook để AI Worker gửi phản hồi kết quả.]
  ),
  caption: [Đặc tả chi tiết các trường dữ liệu của thông điệp hàng chờ],
) <table-queue-job-fields>
#v(6pt)

\- Định dạng `comic_type` quyết định màng lọc thuật toán sắp xếp thứ tự đọc và mô hình AI OCR tương ứng được kích hoạt tại AI Worker (luồng Manga hoặc luồng Webtoon).

=== Đặc tả giao tiếp phản hồi kết quả (Webhook Response Payload)

Sau khi hoàn tất chuỗi tiến trình xử lý hình ảnh và ngôn ngữ, AI Worker gọi phương thức HTTP POST để gửi gói dữ liệu kết quả về cổng Webhook nội bộ của Core Backend.

#[
  #show figure: set block(breakable: false)
  #figure(
    ```json
    {
      "job_id": "string",
      "status": "string",
      "page_id": "string",
      "chapter_id": "string",
      "error": "string",
      "result": {
        "cleaned_img_url": "string",
        "metadata": {
          "original_url": "string",
          "translations": {
            "lang_code": "string"
          }
        }
      }
    }
    ```,
    kind: "code-snippet",
    supplement: [Đoạn mã],
    caption: [Cấu trúc JSON phản hồi từ AI Worker],
  )
]
#v(12pt)

#figure(
  table(
    columns: (2fr, 1.1fr, 2.8fr),
    table.header([*Tên trường*], [*Kiểu dữ liệu*], [*Mô tả*]),
    [`job_id`], [String], [Mã định danh duy nhất của tác vụ xử lý.],
    [`status`], [String], [Trạng thái thực thi đường ống (COMPLETED hoặc FAILED).],
    [`page_id`], [String], [Mã định danh trang truyện vật lý.],
    [`chapter_id`], [String], [Mã định danh chương truyện.],
    [`error`], [String], [Chuỗi thông báo chi tiết mã lỗi nếu trạng thái là FAILED.],
    [`result`], [Object], [Đối tượng chứa thông tin tài nguyên kết quả khi xử lý thành công.],
    [`result.cleaned_img_url`], [String], [Đường dẫn ảnh nền sạch sau khi xóa chữ (Inpainted Image) trên MinIO.],
    [`result.metadata`], [Object], [Đối tượng bọc các liên kết siêu dữ liệu kết quả.],
    [`result.metadata.` \u{200b} `original_url`], [String], [Đường dẫn tải tệp siêu dữ liệu tọa độ gốc original_metadata trên MinIO.],
    [`result.metadata.` \u{200b} `translations`], [Object (Map)], [Mảng ánh xạ mã ngôn ngữ đích sang đường dẫn tệp siêu dữ liệu dịch thuật tương ứng.]
  ),
  caption: [Đặc tả chi tiết các trường dữ liệu của cấu trúc phản hồi Webhook],
) <table-webhook-response-fields>
#v(6pt)

\- Khi Core Backend tiếp nhận gói tin trạng thái `COMPLETED`, hệ thống thực hiện cập nhật các liên kết lưu trữ tài nguyên mới vào các bảng dữ liệu `pages` và `page_translations` trong PostgreSQL để phân phối tới người dùng.

\- Khi Core Backend tiếp nhận gói tin trạng thái `FAILED`, hệ thống log ra thông báo lỗi lên console và cập nhật trạng thái `FAILED` vào bảng `pages`.

== Thiết kế các luồng xử lý nghiệp vụ cốt lõi (Core Business Workflows)

=== Luồng Xác thực, Ủy quyền và Bảo mật Hệ thống

Hệ thống áp dụng kiến trúc bảo mật hỗn hợp (Hybrid Security Architecture), kết hợp song song cơ chế xác thực nội bộ (Local Authentication) thông qua định danh kết hợp mật khẩu và cơ chế ủy quyền phân tán qua đối tác thứ ba (Google OAuth2). Quản lý quyền truy cập được thực hiện theo cơ chế phi trạng thái (Stateless) đối với các API nghiệp vụ thông qua mã thông báo JSON Web Token (JWT).

#figure(
  image("/images/sequence_diagrams/auth_flows/local_auth.svg"),
  caption: [Sơ đồ tuần tự luồng xác thực nội bộ (Local Authentication)],
) <fig-local-auth-sequence>

#v(100pt)

#figure(
  image("/images/sequence_diagrams/auth_flows/oauth2.svg"),
  caption: [Sơ đồ tuần tự luồng ủy quyền qua bên thứ ba (Google OAuth2)],
) <fig-oauth2-sequence>

#figure(
  image("/images/sequence_diagrams/auth_flows/rbac.svg"),
  caption: [Sơ đồ tuần tự luồng kiểm soát phân quyền dựa trên vai trò (RBAC)],
) <fig-rbac-sequence> 

=== Luồng Quản lý và Truy xuất Tài nguyên Nội dung

Các luồng truy xuất nội dung đảm nhiệm vai trò kiểm soát và đồng bộ vòng đời dữ liệu cấu trúc của truyện, chương, trang và danh mục thể loại.

#figure(
  image("/images/sequence_diagrams/comic_mng/createComic.svg"),
  caption: [Sơ đồ tuần tự luồng tạo mới truyện tranh],
) <fig-rbac-sequence> 

#figure(
  image("/images/sequence_diagrams/comic_mng/createCategory.svg"),
  caption: [Sơ đồ tuần tự luồng tạo mới danh mục thể loại],
) <fig-rbac-sequence>

#figure(
  image("/images/sequence_diagrams/comic_mng/createChapterAndUploadPage.svg"),
  caption: [Sơ đồ tuần tự tạo mới chương và tả lên trang truyện],
) <fig-rbac-sequence>

#figure(
  image("/images/sequence_diagrams/comic_mng/getPages.svg"),
  caption: [Sơ đồ tuần tự truy xuất dữ liệu trang truyện],
) <fig-rbac-sequence>

=== Luồng truy vấn dữ liệu tìm kiếm truyện
#figure(  image("/images/sequence_diagrams/search.svg"),
  caption: [Sơ đồ hoạt động mô tả đường ống AI Worker Pipeline (A)]
)

#pagebreak()
== Thiết kế luồng AI (AI Processing Pipeline)

#figure(
  image("/images/activity_diagrams/cropped-ai_pipeline.svg"),
  caption: [Sơ đồ hoạt động mô tả đường ống AI Worker Pipeline (A)]
)

#figure(
  image("/images/activity_diagrams/cropped-ai_pipeline (1).svg"),
  caption: [Sơ đồ hoạt động mô tả đường ống AI Worker Pipeline (B)]
)
#pagebreak()


== Thiết kế Giao diện Người dùng (UI/UX Layout Design)

Hệ thống Next.js Frontend được tổ chức theo kiến trúc hướng thành phần, phân tách rõ ràng giữa các khối giao diện dùng chung và các khối giao diện đặc thù theo từng trang nghiệp vụ.

=== Thành phần cấu trúc cơ sở:
 
Các thành phần đóng vai trò làm khung xương  định hình không gian hiển thị ứng dụng, xuất hiện cố định tại các vùng biên của màn hình:

\- `<Sidebar>` & `<SidebarItem>`: Khung điều hướng dạng thanh dọc đặt ở phía bên trái giao diện Dashboard, hỗ trợ chuyển mạch nhanh giữa các phân khu quản trị và xuất bản.

\- `<Topbar>` & `<TopbarItem>`: Thanh công cụ phía trên cùng, chứa thông tin tài khoản, ảnh đại diện, và các nút thao tác nhanh.

\- `<LanguageToggle>`: Thành phần chuyển đổi ngôn ngữ giao diện thời gian thực.

\- `<ThemeToggle>`: Thành phần chuyển đổi chế độ hiển thị Sáng/Tối (Light/Dark Mode).

=== Thành phần phổ biến dùng chung

Tập hợp các thành phần cốt lõi có tần suất tái sử dụng cao trên toàn bộ hệ thống:

\- `<CButton>`: Thành phần nút bấm chuẩn hóa, đóng gói sẵn các hiệu ứng tương tác (Hover, Active, Loading state).

\- `<CInput>`: Khung nhập liệu đa năng, tích hợp sẵn logic kiểm tra lỗi (Validation) cục bộ cho các biểu mẫu đăng nhập, đăng ký và cập nhật siêu dữ liệu.

\- `<CForm>`: Bộ bọc biểu mẫu (Form Wrapper), đóng vai trò quản lý trạng thái dữ liệu thu thập từ các `<CInput>` con trước khi chuyển giao cho tầng dịch vụ xử lý.

\- `<CModal>`: Hộp thoại nổi (Pop-up overlay) dùng cho các tác vụ xác nhận quan trọng (ví dụ: xác nhận xóa trang truyện, thông báo lỗi hệ thống, hoặc hiển thị cửa sổ tra từ Tap-to-Translate).

=== Các trang nghiệp vụ
\- Trình xem và tương tác truyện

\- Giao diện tải lên chương truyện

\- Trang tổng quan và quản trị