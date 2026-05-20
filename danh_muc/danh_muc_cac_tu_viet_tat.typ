#import "/global_vars.typ": stt, TTS_implemented

#[
  #show heading: set align(center)
  #heading(numbering: none)[Danh mục các từ viết tắt]
]
#table(
  columns: (40pt, 80pt, 145pt, 1fr),
  inset: 10pt,
  align: (center + horizon, center + horizon, left + horizon, left + horizon),
  table.header(
    align(center)[*STT*], align(center)[*Từ viết tắt*], align(center)[*Từ đầy đủ tiếng Anh*], align(center)[*Nghĩa tiếng Việt*]
  ),
  stt(), [AI], [Artificial Intelligence], [Trí tuệ nhân tạo],
  stt(), [API], [Application Programming Interface], [Giao diện lập trình ứng dụng],
  stt(), [ACID], [Atomicity, Consistency, Isolation, Durability], [Tập hợp bốn thuộc tính đảm bảo tính tin cậy của một giao dịch cơ sở dữ liệu bao gồm: tính nguyên tử, tính nhất quán, tính cô lập và tính bền vững],
  stt(), [ASGI], [Asynchronous Server Gateway Interface], [Giao diện cổng dịch vụ máy chủ bất đồng bộ],
  stt(), [CPU], [Central Processing Unit], [Bộ xử lý trung tâm],
  stt(), [ERD], [Entity Relationship Diagram], [Sơ đồ thực thể liên kết],
  stt(), [GPU], [Graphics Processing Unit], [Bộ xử lý đồ họa],
  stt(), [HTML], [HyperText Markup Language], [Ngôn ngữ đánh dấu siêu văn bản],
  stt(), [HTTP], [HyperText Transfer Protocol], [Giao thức truyền tải siêu văn bản],
  stt(), [ISR], [Incremental Static Regeneration], [Cơ chế tái tạo tĩnh gia tăng],
  stt(), [JSON], [JavaScript Object Notation], [Định dạng hoán đổi dữ liệu dạng đối tượng JavaScript],
  stt(), [JWT], [JSON Web Token], [Mã thông báo dựa trên định dạng cấu trúc JSON dùng để xác thực bảo mật],
  stt(), [LLM], [Large Language Model], [Mô hình ngôn ngữ lớn],
  stt(), [OCR], [Optical Character Recognition], [Nhận dạng ký tự quang học],
  stt(), [OAuth2], [Open Authorization 2.0], [Giao thức ủy quyền mở phiên bản 2.0],
  stt(), [RAM], [Random Access Memory], [Bộ nhớ truy cập ngẫu nhiên],
  stt(), [RBAC], [Role-Based Access Control], [Cơ chế kiểm soát truy cập dựa trên vai trò],
  stt(), [REST], [Representational State Transfer], [Kiến trúc chuyển đổi trạng thái đại diện],
  stt(), [S3], [Simple Storage Service], [Dịch vụ lưu trữ đối tượng đơn giản (chuẩn API S3)],
  stt(), [SEO], [Search Engine Optimization], [Tối ưu hóa công cụ tìm kiếm],
  stt(), [SOA], [Service-Oriented Architecture], [Kiến trúc hướng dịch vụ],
  stt(), [SSR], [Server-Side Rendering], [Cơ chế kết xuất đồ họa phía máy chủ],
  
)

#context{if TTS_implemented.get() == true [stt(), [TTS], [Text-to-Speech], [Chuyển đổi văn bản thành giọng nói]]}