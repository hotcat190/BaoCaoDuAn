#import "/global_vars.typ": stt

#[
  #show heading: set align(center)
  #heading(numbering: none)[Danh mục các từ viết tắt]
]
#table(
  columns: (40pt, 80pt, 180pt, 1fr),
  inset: 10pt,
  align: (center + horizon, center + horizon, left + horizon, left + horizon),
  table.header(
    align(center)[*STT*], align(center)[*Từ viết tắt*], align(center)[*Từ đầy đủ tiếng Anh*], align(center)[*Nghĩa tiếng Việt*]
  ),
  stt(), [AI], [Artificial Intelligence], [Trí tuệ nhân tạo],
  stt(), [API], [Application Programming Interface], [Giao diện lập trình ứng dụng],
  stt(), [ERD], [Entity Relationship Diagram], [Sơ đồ thực thể liên kết],
  stt(), [LLM], [Large Language Model], [Mô hình ngôn ngữ lớn],
  stt(), [OCR], [Optical Character Recognition], [Nhận dạng ký tự quang học],
  stt(), [SOA], [Service-Oriented Architecture], [Kiến trúc hướng dịch vụ],
  stt(), [TTS], [Text-to-Speech], [Chuyển đổi văn bản thành giọng nói]
)