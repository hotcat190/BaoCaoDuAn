// Định nghĩa bảng màu (Theme Màu Sáng & Xanh Dương)
#let bg-color = rgb("#ffffff")
#let text-color = rgb("#1e293b")
#let title-color = rgb("#0f2d59")
#let accent-blue = rgb("#2563eb")
#let card-bg = rgb("#f8fafc")
#let card-border = rgb("#e2e8f0")
#let highlight-bg = rgb("#f0f9ff")
#let highlight-border = rgb("#0284c7")
#let green-bg = rgb("#f0fdf4")
#let green-border = rgb("#10b981")
#let green-text = rgb("#15803d")

// Cấu hình chung cho Slide Trình bày
#set page(
  paper: "presentation-16-9",
  margin: (top: 1.5cm, bottom: 1.5cm, left: 2cm, right: 2cm),
  fill: bg-color, // Nền sáng
  footer: context {
    let page-num = counter(page).get().first()
    if page-num > 1 [
      #block(width: 100%, inset: (top: 8pt), stroke: (top: 1pt + card-border))[
        #grid(
          columns: (1fr, 1fr),
          align(left)[#text(size: 12pt, fill: rgb("#64748b"))[Khóa luận Tốt nghiệp - Trường Đại học Công nghệ, ĐHQGHN]],
          align(right)[#text(size: 12pt, fill: rgb("#64748b"))[Trang #page-num / 15]]
        )
      ]
    ]
  }
)

#set text(
  font: "SVN-Times New Roman",
  fill: text-color, // Chữ tối
  size: 20pt,
)

// Các hàm bổ trợ thiết kế layout slide
#let title-slide(title, subtitle, author, supervisor, institution) = {
  align(center + horizon)[
    #block(
      width: 100%,
      inset: (top: 30pt, bottom: 30pt, left: 20pt, right: 20pt),
      stroke: 2pt + accent-blue,
      radius: 12pt,
      fill: card-bg
    )[
      #text(size: 28pt, weight: "bold", fill: title-color)[#title]
      #if subtitle != "" [
        #v(12pt)
        #text(size: 18pt, style: "italic", fill: rgb("#475569"))[#subtitle]
      ]
    ]
    #v(30pt)
    #grid(
      columns: (1.2fr, 1fr),
      align(left)[
        #text(size: 16pt, fill: text-color)[
          *Sinh viên thực hiện:* #author \
          *Đơn vị:* #institution
        ]
      ],
      align(left)[
        #text(size: 16pt, fill: text-color)[
          *Giảng viên hướng dẫn:* #supervisor
        ]
      ]
    )
  ]
}

#let slide(title, body) = {
  pagebreak(weak: true)
  block(width: 100%, height: 100%)[
    #grid(
      columns: (1fr),
      row-gutter: 15pt,
      block(width: 100%, inset: (bottom: 8pt), stroke: (bottom: 2pt + accent-blue))[
        #text(size: 24pt, weight: "bold", fill: title-color)[#title]
      ],
      body
    )
  ]
}

// ==========================================
// SLIDE 1: Slide Mở đầu / Tiêu đề
// ==========================================
#title-slide(
  "Phát Triển Ứng Dụng Đọc Truyện Tranh Hỗ Trợ Đa Ngôn Ngữ Bằng Việc Ứng Dụng AI Tự Động Dịch",
  "Nghiên cứu và tích hợp các mô hình học sâu (OCR, Inpainting, LLM) và kiến trúc xử lý bất đồng bộ",
  "Nhóm sinh viên thực hiện",
  "Giảng viên hướng dẫn",
  "Trường Đại học Công nghệ - ĐHQGHN"
)

// ==========================================
// SLIDE 2: Đặt vấn đề & Mục tiêu đề tài
// ==========================================
#slide("1. Đặt vấn đề & Mục tiêu đề tài", [
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *Hiện trạng:*
      #list(
        [Quy trình dịch thuật truyền thống (*Scanlation*) thủ công tốn thời gian, chi phí lớn.],
        [Chữ dịch bị *nhúng cứng (hardcoded)* vào điểm ảnh, làm mất thông tin số và khả năng tương tác.]
      )
    ],
    [
      *Mục tiêu cốt lõi:*
      #list(
        [Tự động hóa quy trình dịch thuật bằng *Pipeline AI bất đồng bộ*.],
        [*Tách biệt* lớp ảnh nền sạch (Cleaned Background) và siêu dữ liệu văn bản dịch.],
        [Tính năng tương tác *Tap-to-Translate* hỗ trợ tra từ vựng theo ngữ cảnh khi đọc.]
      )
    ]
  )
])

// ==========================================
// SLIDE 3: Phân tích định dạng & Thách thức
// ==========================================
#slide("2. Định dạng truyện tranh & Thách thức AI", [
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 15pt,
    [
      *Đặc điểm định dạng:*
      - *Manga*: Đọc phải sang trái; chữ dọc; bong bóng thoại elip đứng; từ tượng thanh đè nền.
      - *Webtoon*: Cuộn dọc vô hạn; khoảng trống lớn; bong bóng thưa; chữ ngang.
      #v(8pt)
      #grid(
        columns: (1fr, 1fr),
        gutter: 10pt,
        align(center)[
          #image("../images/nekodama_002.jpg", height: 120pt)
          #v(-4pt)
          #text(size: 10pt, fill: rgb("#64748b"))[Manga (Page-based)]
        ],
        align(center)[
          #image("../images/msedge_xjHnK9kcWs.png", height: 120pt)
          #v(-4pt)
          #text(size: 10pt, fill: rgb("#64748b"))[Webtoon (Scroll)]
        ]
      )
    ],
    [
      #block(fill: card-bg, inset: 12pt, radius: 6pt, stroke: 1pt + card-border)[
        *Thách thức kỹ thuật:*
        - *Hình học bong bóng thoại*: Biến dạng đa dạng (elip, tia chớp, mây, không viền).
        - *Giao thoa đồ họa*: Chữ đè lên chi tiết nền phức tạp (tóc, bối cảnh).
        - *Thứ tự đọc (Reading Order)*: Sắp xếp logic ô chữ theo mạch truyện.
      ]
    ]
  )
])

// ==========================================
// SLIDE 4: Giải pháp đề xuất & Mô hình AI sử dụng
// ==========================================
#slide("3. Giải pháp đề xuất & Mô hình AI", [
  #grid(
    columns: (1fr, 1fr),
    gutter: 7pt,
    [
      #block(fill: card-bg, inset: 10pt, radius: 6pt, stroke: 1pt + card-border)[
        *Phân tách khung tranh (Panel)*
        - Sử dụng *YOLOv12*: trích xuất đặc trưng đa tầng và cơ chế chú ý cải tiến, nhận diện ranh giới ô tranh bất đối xứng rất nhanh và chính xác.
      ]
      #block(fill: card-bg, inset: 10pt, radius: 6pt, stroke: 1pt + card-border)[
        *Nhận dạng chữ (OCR)*
        - *Manga*: DBNet (`comic-text-detector`) định vị bong bóng thoại + `MangaOcr` nhận diện chữ dọc nghệ thuật.
        - *Webtoon*: `PaddleOCR-v5` nhận diện ngang đa hướng.
      ]
    ],
    [      
      #block(fill: highlight-bg, inset: 12pt, radius: 8pt, stroke: 1.5pt + highlight-border)[
        *Xóa chữ & Phục hồi ảnh nền (Inpainting)*
        - *Mạng học sâu LaMa*: Sử dụng *Fast Fourier Convolution (FFC)* để có trường thụ cảm toàn cục.
        - *Kết quả*: Tự động khôi phục cấu trúc lưới bóng (screentone) và họa tiết nền tự nhiên mà không bị nhòe mờ.
      ]
    ]
  )
])

// ==========================================
// SLIDE 5: Dịch thuật ngữ cảnh với Gemini LLM
// ==========================================
#slide("4. Dịch thuật ngữ cảnh với Gemini LLM", [
  #grid(
    columns: (1.1fr, 1fr),
    gutter: 20pt,
    [
      *Hạn chế dịch thô (Text-only API):*
      - Không có ngữ cảnh hình ảnh để xác định giới tính/biểu cảm $arrow.r$ Sai đại từ xưng hô ("tớ - cậu", "ta - ngươi").
      
      *Giải pháp với Gemini 3.1 Flash-Lite:*
      - *Visual Context-Aware*: Truyền đồng thời văn bản gốc và ảnh *Set-of-Mark (SoM)* (ảnh có vẽ các ô chữ được đánh dấu màu) để LLM đối chiếu ngữ cảnh hình ảnh.
      - *Định dạng đầu ra có cấu trúc*: Sử dụng cơ chế JSON Schema ràng buộc chặt chẽ để trả về dữ liệu chuẩn xác.
    ],
    [
      #align(center + horizon)[
        #block(fill: card-bg, inset: 15pt, radius: 8pt, stroke: 1.5pt + card-border)[
          #text(weight: "bold", fill: accent-blue)[Đóng gói JSON Output]
          #v(8pt)
          #set text(size: 15pt, font: "Consolas", fill: text-color)
          ```json
          {
            "page_id": "p001",
            "bubbles": [
              {
                "id": 1,
                "full_translation": "Cậu đang làm gì thế?",
                "chunk_meanings": [...]
              }
            ]
          }
          ```
        ]
      ]
    ]
  )
])

// ==========================================
// SLIDE 6: Kiến trúc tổng thể hệ thống (Hybrid SOA)
// ==========================================
#slide("5. Kiến trúc tổng thể hệ thống", [
  #align(center + horizon)[
        #image("../images/Architecture-2026-05-20-180834.png", width: 90%)
      ]
])

// ==========================================
// SLIDE 7: Giải pháp xử lý bất đồng bộ (RabbitMQ)
// ==========================================
#slide("6. Xử lý bất đồng bộ qua RabbitMQ", [
  #grid(
    columns: (1fr, 1.25fr),
    gutter: 15pt,
    [
      *Nút thắt cổ chai hệ thống:*
      - Xử lý AI tốn tài nguyên và thời gian.
      - HTTP đồng bộ dễ gây *Thread Starvation* và *HTTP Timeout*.
      
      *Cơ chế RabbitMQ bất đồng bộ:*
      1. *Spring Boot*: Nhận file, lưu MinIO, đẩy Job Payload vào Queue $arrow.r$ phản hồi ngay *HTTP 201*.
      2. *RabbitMQ Queue*: Hàng đợi lưu đệm, co giãn tải tự động.
      3. *FastAPI AI Worker*: Lắng nghe Queue, chạy AI pipeline độc lập.
      4. *Callback*: POST Webhook cập nhật kết quả.
    ],
    [
      #align(center + horizon)[
        #image("../images/sequence_diagrams/async_upload_flows/upload_chapter.svg", width: 95%)
      ]
    ]
  )
])

// ==========================================
// SLIDE 8: Phân tích yêu cầu chức năng (Use Cases)
// ==========================================
#slide("7. Phân tích yêu cầu chức năng", [
  #grid(
    columns: (1fr, 1.2fr),
    gutter: 15pt,
    [
      *Phân nhóm vai trò (Roles):*
      #v(5pt)
      - *Guest*: Duyệt & tìm kiếm (Elasticsearch), đọc thử, trải nghiệm *Tap-to-Translate*.
      - *User*: Quản lý tủ sách, đồng bộ tiến độ đọc, bình luận phân nhánh.
      - *Admin*: Quản lý nội dung (truyện/chương), kích hoạt *AI Pipeline*, phân quyền.
    ],
    [
      #align(center + horizon)[
        #image("../images/use_case.svg", width: 100%)
      ]
    ]
  )
])

// ==========================================
// SLIDE 9: Thiết kế CSDL & Polyglot Persistence
// ==========================================
#slide("8. Thiết kế CSDL & Polyglot Persistence", [
  #grid(
    columns: (1fr, 1.3fr),
    gutter: 15pt,
    [
      *Kiến trúc lưu trữ đa tầng (Polyglot):*
      #v(5pt)
      - *PostgreSQL*: Lưu dữ liệu nghiệp vụ quan hệ (Users, Comics, Chapters), quản lý hạn mức AI.
      - *Elasticsearch*: Tìm kiếm mờ tên truyện đa ngôn ngữ bằng chỉ mục đảo ngược.
      - *Redis & Caffeine*: Cache phân tán/cục bộ tăng tốc phản hồi API.
      - *MinIO*: Object Storage lưu ảnh sạch và JSON metadata.
    ],
    [
      #align(center + horizon)[
        #image("../images/ERD_2026-05-20-181407.svg", width: 100%)
      ]
    ]
  )
])

// ==========================================
// SLIDE 10: Thiết kế siêu dữ liệu tách biệt (Metadata)
// ==========================================
#slide("9. Thiết kế siêu dữ liệu (Metadata)", [
  *Ý tưởng cốt lõi*: Không vẽ đè chữ lên ảnh. Lưu trữ metadata JSON riêng biệt.
  #v(10pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *original_metadata.json (Tọa độ gốc):*
      - Lưu danh sách `bubbles[].box`: Tọa độ pixel $[x, y, w, h]$.
      - Lưu chữ gốc `original_text` và phiên âm `romanization`.
    ],
    [
      *translation_metadata.json (Bản dịch):*
      - Ánh xạ qua `bubbles[].id` trùng khớp với tệp gốc.
      - Lưu dịch nghĩa `full_translation` và chi tiết giải nghĩa từng từ `chunk_meanings` (cho pop-up).
    ]
  )
])

// ==========================================
// SLIDE 11: Chi tiết luồng xử lý AI Pipeline
// ==========================================
#slide("10. Luồng xử lý tại AI Pipeline", [
  #grid(
    columns: (1.1fr, 1fr),
    gutter: 15pt,    
    [
      #align(center + horizon)[
        #image("../images/activity_diagrams/cropped-ai_pipeline.svg", height: 95%)
      ]
    ],
    [
      #align(center + horizon)[
        #image("../images/activity_diagrams/cropped-ai_pipeline (1).svg", height: 95%)
      ]
    ]
  )
])

// ==========================================
// SLIDE 12: Cài đặt và Triển khai thực tế
// ==========================================
#slide("11. Cài đặt và Triển khai thực tế", [
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *Frontend (Next.js 16 & React 19):*
      - *Zustand*: Quản lý state phiên làm việc.
      - *React Query & Axios*: Caching & API sync.
      - *Tailwind CSS v4*: Responsive & Dark Mode.
      - *React Intl*: Bản địa hóa đa ngôn ngữ.
    ],
    [
      *Backend & AI Service:*
      - *Spring Boot 3.5*: Bảo mật JWT, JPA, Elasticsearch, Redis.
      - *FastAPI*: Lập trình bất đồng bộ, google-genai SDK, aio-pika, ultralytics, simple-lama, paddleocr.
      - *Docker & Compose*: Đóng gói container đồng bộ toàn hệ thống.
    ]
  )
])

// ==========================================
// SLIDE 13: Đảm bảo chất lượng & Kiểm thử
// ==========================================
#slide("12. Kiểm thử & Đảm bảo chất lượng", [
  #set text(size: 18pt)
  #grid(
    columns: (1.1fr, 1fr),
    gutter: 15pt,
    [
      *Kiểm thử Frontend & Backend:*
      - *Frontend*: Phân tích tĩnh với ESLint & TypeScript.
      - *Backend*:
        - JUnit 5 & Mockito: Test đơn vị và tích hợp.
        - *JaCoCo*: Đo lường độ bao phủ code coverage.
        - *PiTest (Mutation Testing)*: Đánh giá chất lượng test case qua lỗi đột biến nhân tạo.
    ],
    [
      *Kiểm thử AI Pipeline:*
      - *pytest*: Test đơn vị thuật toán sắp xếp ô tranh (`panel_sorter`, XY Cut).
      - *test_pipeline.py*: CLI tool test tích hợp cục bộ độc lập (không cần RabbitMQ).
      - *Visual/Position Debugger*: Xuất ảnh bounding box trung gian kiểm tra trực quan.
    ]
  )
])

// ==========================================
// SLIDE 14: Đánh giá chất lượng
// ==========================================
#slide("13. Đánh giá chất lượng", [
  #set text(size: 18pt)
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 15pt,
    [
      *Đo lường định lượng:*
      - *Thời gian xử lý*: ~11.17s/trang (gồm dịch Gemini API 1.5-3s, còn lại OCR/Inpaint CPU cục bộ).
      - *Tỷ lệ lỗi ký tự (CER)*: MangaOcr ~6-10%, PaddleOCR ~5-8%.
      
      *Đánh giá định tính:*
      - *LaMa Inpainting*: Tái tạo nền sạch, giữ nguyên screentones Manga.
      - *Gemini 3.1 Flash-Lite*: Dịch tự nhiên, xưng hô chuẩn xác nhờ ngữ cảnh hình ảnh.
    ],
    [
      #align(center + horizon)[
        #image("../images/pipeline_text_blocks.png", width: 95%)
        #v(-5pt)
        #text(size: 11pt, style: "italic", fill: rgb("#64748b"))[Ảnh gỡ lỗi nhận diện hộp thoại (Arisa © Yagami Ken)]
      ]
    ]
  )
])

// ==========================================
// SLIDE 15: Kết luận & Hướng phát triển tương lai
// ==========================================
#slide("14. Kết luận & Hướng phát triển", [
  #grid(
    columns: (1fr, 1fr),
    gutter: 20pt,
    [
      *Kết quả đạt được:*
      - Xây dựng thành công *AI Pipeline* tự động hóa dịch thuật truyện tranh.
      - Áp dụng *RabbitMQ* xử lý bất đồng bộ, giải quyết nút thắt cổ chai.
      - *Tách biệt* lớp phủ chữ động và ảnh sạch, tối ưu lưu trữ.
    ],
    [
      *Định hướng tương lai:*
      - Nghiên cứu *fine-tune OCR* nội bộ cho font chữ nghệ thuật/viết tay.
      - Nâng cấp inpainting với *GAN/Diffusion* cải thiện mỹ thuật bối cảnh.
      - Triển khai *Autoscaling* AI Worker trên Cloud theo hàng đợi RabbitMQ.
    ]
  )
])
