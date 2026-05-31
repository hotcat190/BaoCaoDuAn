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
    let total-pages = counter(page).final().first()
    if page-num > 1 [
      #block(width: 100%, inset: (top: 8pt), stroke: (top: 1pt + card-border))[
        #grid(
          columns: (1fr, 1fr),
          align(left)[#text(size: 12pt, fill: rgb("#64748b"))[Khoa CNTT - Trường Đại học Công nghệ, ĐHQGHN]],
          align(right)[#text(size: 12pt, fill: rgb("#64748b"))[Trang #page-num / #total-pages]]
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
  block(width: 100%, height: 100%, breakable: false)[
    #grid(
      columns: (1fr, auto),
      align(left + horizon)[
        #text(size: 11pt, weight: "bold", fill: title-color)[
          ĐẠI HỌC QUỐC GIA HÀ NỘI \
          TRƯỜNG ĐẠI HỌC CÔNG NGHỆ
        ]
      ],
      align(right + horizon)[
        #image("../images/Logo_HUET.svg", height: 35pt)
      ]
    )
    #v(-4pt)
    #line(length: 100%, stroke: 0.5pt + card-border)
    #v(10pt)
    
    #align(center + horizon)[
      #block(
        width: 100%,
        inset: (top: 15pt, bottom: 15pt, left: 70pt, right: 70pt),
        stroke: 2pt + accent-blue,
        radius: 10pt,
        fill: card-bg
      )[
        #text(size: 22pt, weight: "bold", fill: title-color)[#title]
        #if subtitle != "" [
          #v(8pt)
          #text(size: 14pt, style: "italic", fill: rgb("#475569"))[#subtitle]
        ]
      ]
      #v(10pt)
      #grid(
        columns: (1.2fr, 1fr),
        gutter: 20pt,
        align(left)[
          #text(size: 13pt, fill: text-color)[
            *Sinh viên thực hiện:* \
            #author \
            *Ngành:* #institution
          ]
        ],
        align(top + left)[
          #text(size: 13pt, fill: text-color)[
            *Giảng viên hướng dẫn:* \
            #supervisor
          ]
        ]
      )
    ]
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
  "Phát triển ứng dụng đọc truyện tranh hỗ trợ đa ngôn ngữ bằng việc ứng dụng AI tự động dịch",
  "Nghiên cứu và tích hợp các mô hình học sâu (OCR, Inpainting, LLM) và kiến trúc xử lý bất đồng bộ",
  [
    Nguyễn Đình Nguyên (22021141) \
    Hoàng Lê Kim Long (22021216) \
    Hoàng Công Hữu (22021178) \
  ],
  [TS. Lê Hồng Hải],
  "Công nghệ thông tin"
)

// ==========================================
// SLIDE 2: Đặt vấn đề & Mục tiêu đề tài
// ==========================================
#slide("Đặt vấn đề & Mục tiêu đề tài", [
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
        [*Tách biệt* lớp ảnh nền sạch (Cleaned Background) và văn bản dịch.],
        [Tính năng tương tác *Tap-to-Translate* hỗ trợ tra từ vựng theo ngữ cảnh khi đọc.]
      )
    ]
  )
])

// ==========================================
// SLIDE 3: Phân tích định dạng & Thách thức
// ==========================================
#slide("Định dạng truyện tranh & Thách thức kỹ thuật", [
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
// SLIDE 4: Giải pháp đề xuất: Số hóa cấu trúc trang truyện
// ==========================================
#slide("Giải pháp đề xuất: Số hóa cấu trúc trang truyện", [
  #grid(
    columns: (1fr, 1.2fr),
    gutter: 20pt,
    [
      *Tư tưởng cốt lõi:*
      #list(
        [Không nhúng cứng bản dịch vào các điểm ảnh của file đồ họa.],
        [Phân tách triệt để giữa *hình ảnh nền sạch* (Cleaned Background) và *lớp chữ dịch động* (Dynamic Text Layer).],
        [Client render động văn bản dịch đè lên tọa độ pixel tương ứng.]
      )
    ],
    [
      #block(fill: highlight-bg, inset: 12pt, radius: 8pt, stroke: 1.5pt + highlight-border)[
        *Quy trình tự động hóa với AI Pipeline:*
        1. *Phân tách ô tranh (Panels)* $arrow.r$ Xác định ranh giới kể chuyện.
        2. *Dò & nhận dạng chữ (OCR)* $arrow.r$ Trích xuất văn bản gốc.
        3. *Xóa chữ phục hồi nền (Inpainting)* $arrow.r$ Tạo ảnh sạch chữ.
        4. *Dịch thuật ngữ cảnh (LLM)* $arrow.r$ Bản dịch tự nhiên.
      ]
    ]
  )
])

// ==========================================
// SLIDE 5: Công nghệ AI: Nhận diện khung tranh (YOLOv12)
// ==========================================
#slide("Công nghệ AI: Nhận diện khung tranh (YOLOv12)", [
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 20pt,
    [
      *Lý do lựa chọn YOLOv12:*
      - Trích xuất đặc trưng đa tầng và cơ chế chú ý (attention mechanism) cải tiến.
      - Nhận diện ranh giới ô tranh bất đối xứng rất nhanh và chính xác.
      
      *Vai trò trong Pipeline:*
      - Phân tách trang truyện thành các khung tranh (panels) độc lập.
      - Sắp xếp thứ tự đọc (Reading Order - XY Cut) hoạt động chuẩn xác trên Manga và Webtoon.
    ],
    [
      #align(center + horizon)[
        #image("../images/pipeline_panels_sorted.png", width: 100%)
        #v(-4pt)
        #text(size: 10pt, fill: rgb("#64748b"))[Kết quả phân tách ô tranh bằng YOLOv12]
      ]
    ]
  )
])

// ==========================================
// SLIDE 6: Công nghệ AI: Định vị vùng chữ (comic-text-detector)
// ==========================================
#slide("Công nghệ AI: Định vị vùng chữ (comic-text-detector)", [
  #grid(
    columns: (1fr, 1.2fr),
    gutter: 20pt,
    [
      *Đặc điểm mô hình:*
      - Dựa trên mạng dò tìm văn bản *DBNet (Differentiable Binarization)*.
      - Được huấn luyện đặc thù trên tập dữ liệu truyện tranh.
      
      *Ưu điểm:*
      - Định vị chính xác tọa độ các bounding box của bong bóng thoại (bubbles) và các cụm chữ tự do (onomatopoeia).
      - Bỏ qua các chi tiết gây nhiễu trên nền tranh vẽ.
    ],
    [
      #align(center + horizon)[
        #image("../images/pipeline_text_blocks.png", height: 80%)
        #v(-4pt)
        #text(size: 10pt, fill: rgb("#64748b"))[Kết quả dò tìm vùng chữ bằng comic-text-detector]
      ]
    ]
  )
])

// ==========================================
// SLIDE 7: Công nghệ AI: Nhận diện chữ dọc Manga (MangaOcr)
// ==========================================
#slide("Công nghệ AI: Nhận diện chữ dọc Manga (MangaOcr)", [
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 20pt,
    [
      *Kiến trúc End-to-End:*
      - Vision Encoder: *ViT (Vision Transformer)*.
      - Text Decoder: *RoBERTa (Transformer-based)*.
      
      *Thế mạnh vượt trội:*
      - Nhận diện ký tự tiếng Nhật viết dọc nghệ thuật.
      - Xử lý xuất sắc các font chữ cách điệu, độ tương phản thấp hoặc chữ viết tay (handwritten) phổ biến trong Manga.
      - Tỷ lệ lỗi ký tự (CER) thấp (~6-10%).
    ],
    [
      #align(center + horizon)[
        #image("../images/nekodama_002.jpg", height: 80%)
        #v(-4pt)
        #text(size: 10pt, fill: rgb("#64748b"))[Manga Nhật Bản với chữ viết dọc]
      ]
    ]
  )
])

// ==========================================
// SLIDE 8: Công nghệ AI: Nhận diện chữ ngang Webtoon (PaddleOCR-v5)
// ==========================================
#slide("Công nghệ AI: Nhận diện chữ ngang Webtoon (PaddleOCR-v5)", [
  #grid(
    columns: (1fr, 1.2fr),
    gutter: 20pt,
    [
      *Kiến trúc và Thuật toán:*
      - Tích hợp thuật toán dò chữ đa hướng (*Rotated Text Detection*).
      - Cơ chế nhận diện từ ngữ theo từ điển ngôn ngữ tối ưu (PP-OCRv5).
      
      *Lợi thế thực tiễn:*
      - Phù hợp với chữ viết ngang của tiếng Hàn (Manhwa), tiếng Trung (Manhua).
      - Độ chính xác cao, thời gian xử lý nhanh trên các máy chủ có hiệu năng trung bình.
    ],
    [
      #align(center + horizon)[
        #image("../images/msedge_xjHnK9kcWs.png", height: 80%)
        #v(-4pt)
        #text(size: 10pt, fill: rgb("#64748b"))[Webtoon Hàn Quốc với chữ viết ngang]
      ]
    ]
  )
])

// ==========================================
// SLIDE 9: Công nghệ AI: Phục hồi ảnh nền (LaMa Inpainting)
// ==========================================
#slide("Công nghệ AI: Phục hồi ảnh nền (LaMa Inpainting)", [
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 20pt,
    [
      *Mạng học sâu LaMa (Large Mask Inpainting):*
      - Sử dụng các lớp *Fast Fourier Convolution (FFC)* làm cốt lõi.
      - Cung cấp trường thụ cảm toàn cục (receptive field) ngay từ những lớp mạng đầu tiên.
      
      *Hiệu quả phục hồi:*
      - Xóa chữ cũ và tự động khôi phục cấu trúc lưới bóng (screentone) và họa tiết nền tự nhiên mà không bị nhòe mờ.
    ],
    [
      #align(center + horizon)[
        #image("../images/clean (1).jpg", width: 95%)
        #v(-5pt)
        #text(size: 10pt, style: "italic", fill: rgb("#64748b"))[Ảnh trang truyện đã qua Inpainting]
      ]
    ]
  )
])

// ==========================================
// SLIDE 10: Dịch thuật ngữ cảnh với Gemini LLM
// ==========================================
#slide("Dịch thuật ngữ cảnh với Gemini LLM", [
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
        #image("../images/som_image.jpg", width: 95%)
        #v(-5pt)
        #text(size: 11pt, style: "italic", fill: rgb("#64748b"))[Ảnh Set-of-Mark, MAD_STONE © Masaki Hidehisa]
      ]
    ]
  )
])

// ==========================================
// SLIDE 11: Phân tích yêu cầu chức năng (Use Cases)
// ==========================================
#slide("Phân tích yêu cầu chức năng", [
  #grid(
    columns: (1fr, 1.2fr),
    gutter: 15pt,
    [
      *Phân nhóm vai trò (Roles):*
      #v(5pt)
      - *Guest*: Duyệt & tìm kiếm (Elasticsearch), đọc thử, trải nghiệm *Tap-to-Translate*.
      - *User*: Quản lý tủ sách, đồng bộ tiến độ đọc, bình luận.
      - *Admin*: Quản lý nội dung (truyện/chương), kích hoạt *AI Pipeline*, phân quyền.
    ],
    [
      #align(center + horizon)[
        #image("../images/use_case.svg", height: 85%)
      ]
    ]
  )
])

// ==========================================
// SLIDE 12: Kiến trúc tổng thể hệ thống (Hybrid SOA)
// ==========================================
#slide("Kiến trúc tổng thể hệ thống", [
  #align(center + horizon)[
        #image("../images/Architecture-2026-05-20-180834.png", width: 90%)
      ]
])

// ==========================================
// SLIDE 13: Xử lý bất đồng bộ qua RabbitMQ
// ==========================================
#slide("Xử lý bất đồng bộ qua RabbitMQ", [
  #grid(
    columns: (1fr),
    gutter: 15pt,
    text(size: 18pt)[
      *Nút thắt cổ chai hệ thống:*
      - Xử lý AI tốn tài nguyên và thời gian.
      - HTTP đồng bộ dễ gây *Thread Starvation* và *HTTP Timeout*.
      
      #v(6pt)
      *Cơ chế RabbitMQ bất đồng bộ:*
      1. *Spring Boot*: Nhận file, lưu MinIO, đẩy Job Payload vào Queue $arrow.r$ phản hồi ngay *HTTP 201*.
      2. *RabbitMQ Queue*: Hàng đợi lưu đệm, co giãn tải tự động.
      3. *FastAPI AI Worker*: Lắng nghe Queue, chạy AI pipeline độc lập.
      4. *Callback*: POST Webhook cập nhật kết quả.
    ]
  )
])

// ==========================================
// SLIDE 14: Thiết kế CSDL & Polyglot Persistence
// ==========================================
#slide("Thiết kế CSDL & Polyglot Persistence", [
  #grid(
    columns: (1fr, 1.3fr),
    gutter: 15pt,
    [
      *Kiến trúc lưu trữ đa tầng (Polyglot):*
      #v(5pt)
      - *PostgreSQL*: Lưu dữ liệu nghiệp vụ quan hệ (Users, Comics, Chapters).
      - *ElasticSearch*: Tìm kiếm mờ (Fuzzy Search) tên truyện bằng chỉ mục đảo ngược.
      - *Redis & Caffeine*: Cache phân tán/cục bộ tăng tốc phản hồi API.
      - *MinIO*: Object Storage lưu ảnh sạch và JSON metadata.
    ],
    [
      #align(center + horizon)[
        #image("../images/Database-Schema-2026-05-24-120154.png", height: 90%)
      ]
    ]
  )
])

// ==========================================
// SLIDE 15: Thiết kế cấu trúc JSON Metadata
// ==========================================
#slide("Thiết kế cấu trúc JSON Metadata", [
  #v(5pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    [
      #text(weight: "bold", fill: accent-blue)[original_metadata.json (Tọa độ gốc)]
      #v(4pt)
      #block(fill: card-bg, inset: 10pt, radius: 6pt, stroke: 1.2pt + card-border, width: 100%)[
        #set text(size: 13pt, font: "Cascadia Mono", fill: text-color)
        ```json
        {
          "page_id": "45",
          "bubbles": [
            {
              "id": 1,
              "box": [178, 587, 234, 66],
              "original_text": "크크크",
              "chunks": [
                {
                  "chunk_id": "1-1",
                  "word": "크크크",
                  "romanization": "keu-keu-keu"
                }
              ]
            }
          ]
        }
        ```
      ]
    ],
    [
      #text(weight: "bold", fill: accent-blue)[translation_metadata.json (Bản dịch)]
      #v(4pt)
      #block(fill: card-bg, inset: 10pt, radius: 6pt, stroke: 1.2pt + card-border, width: 100%)[
        #set text(size: 13pt, font: "Cascadia Mono", fill: text-color)
        ```json
        {
          "page_id": "45",
          "bubbles": [
            {
              "id": 1,
              "full_translation": "Khà khà khà",
              "chunk_meanings": [
                {
                  "chunk_id": "1-1",
                  "type": "từ tượng thanh",
                  "meaning": "Tiếng cười khà khà"
                }
              ]
            }
          ]
        }
        ```
      ]
    ]
  )
])

// ==========================================
// SLIDE 16: Cài đặt và Triển khai thực tế
// ==========================================
#slide("Cài đặt và Triển khai thực tế", [
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
      - *Docker Compose*: Đóng gói container đồng bộ toàn hệ thống.
    ]
  )
])

// ==========================================
// SLIDE 17: Kiểm thử & Đảm bảo chất lượng
// ==========================================
#slide("Kiểm thử & Đảm bảo chất lượng", [
  #set text(size: 18pt)
  #grid(
    columns: (1.1fr, 1fr),
    gutter: 15pt,
    [
      *Kiểm thử Frontend & Backend:*
      - *Frontend*: Phân tích tĩnh với ESLint & TypeScript.
      - *Backend*:
        - *JUnit 5 & Mockito*: Test đơn vị và tích hợp.
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
// SLIDE 18: Demo ứng dụng: Trình xem truyện thông minh
// ==========================================
#slide("Demo ứng dụng: Trình xem truyện thông minh", [
  #grid(
    columns: (1fr, 1.2fr),
    gutter: 20pt,
    [
      *Tính năng nổi bật:*
      - Giao diện Comic Viewer tối giản, tập trung trải nghiệm đọc.
      - Tải ảnh nền sạch (cleaned background) kết hợp render động lớp chữ dịch đè lên.
      - Pre-load thông minh tăng tốc chuyển trang.
      - Tự động lưu lịch sử tiến trình đọc.
    ],
    [
      #align(center + horizon)[
        #image("../images/comic_viewer.png", height: 85%)
        #v(-4pt)
        #text(size: 10pt, fill: rgb("#64748b"))[Giao diện đọc truyện tranh Next.js]
      ]
    ]
  )
])

// ==========================================
// SLIDE 19: Demo ứng dụng: Tính năng Tap-to-Translate
// ==========================================
#slide("Demo ứng dụng: Tính năng Tap-to-Translate", [
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 20pt,
    [
      *Tương tác tra từ vựng:*
      - Độc giả rê chuột hoặc chạm vào một từ/phân đoạn cụ thể trên trang truyện.
      - Vùng chữ được chọn sẽ được highlight sáng.
      - Hệ thống hiển thị pop-up chứa từ gốc, phiên âm Romaji, từ loại và nghĩa dịch chi tiết.
    ],
    [
      #align(center + horizon)[
        #image("../images/hover_mad_stone1.png", width: 95%)
        #v(-5pt)
        #text(size: 10pt, fill: rgb("#64748b"))[Pop-up tra từ vựng trực tiếp khi di chuột]
      ]
    ]
  )
])

// ==========================================
// SLIDE 20: Demo ứng dụng: Hiển thị bản dịch đầy đủ
// ==========================================
#slide("Demo ứng dụng: Hiển thị bản dịch đầy đủ", [
  #grid(
    columns: (1fr, 1.2fr),
    gutter: 20pt,
    [
      *Chuyển đổi ngôn ngữ dịch:*
      - Hỗ trợ chuyển đổi nhanh hiển thị bản dịch tiếng Anh/tiếng Việt đè lên vị trí thoại cũ.
      - Typesetting căn chỉnh kích thước font chữ, khoảng cách dòng tự động khít với bong bóng thoại gốc.
    ],
    [
      #align(center + horizon)[
        #image("../images/ban_dich_full_mad_stone.png", width: 95%)
        #v(-5pt)
        #text(size: 10pt, fill: rgb("#64748b"))[Trang truyện được hiển thị đè chữ dịch tiếng Việt]
      ]
    ]
  )
])

// ==========================================
// SLIDE 21: Demo ứng dụng: Tổng quan trang quản trị Admin
// ==========================================
#slide("Demo ứng dụng: Tổng quan trang quản trị Admin", [
  #grid(
    columns: (1fr, 1.2fr),
    gutter: 20pt,
    [
      *Dashboard điều khiển:*
      - Admin theo dõi tổng quan hệ thống: Tổng số người dùng, bộ truyện, chương truyện đang phát hành.
      - Thống kê hạn mức (quota) gọi API dịch AI trong ngày.
      - Danh sách truyện mới cập nhật và danh mục phân loại.
    ],
    [
      #align(center + horizon)[
        #image("../images/admin_overview.png", height: 85%)
        #v(-4pt)
        #text(size: 10pt, fill: rgb("#64748b"))[Giao diện quản trị hệ thống đọc truyện]
      ]
    ]
  )
])

// ==========================================
// SLIDE 22: Demo ứng dụng: Giao diện đăng truyện mới
// ==========================================
#slide("Demo ứng dụng: Giao diện đăng truyện mới", [
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 20pt,
    [
      *Giao diện đăng tác phẩm:*
      - Nhập các siêu dữ liệu cấu trúc: Tên truyện, tác giả, thể loại, ngôn ngữ gốc (Nhật, Hàn, Trung).
      - Tải lên ảnh bìa đại diện cho bộ truyện.
      - Tích hợp tìm kiếm phân loại và đồng bộ chỉ mục Elasticsearch.
    ],
    [
      #align(center + horizon)[
        #image("../images/dang_truyen_moi.png", height: 85%)
        #v(-4pt)
        #text(size: 10pt, fill: rgb("#64748b"))[Giao diện nhập thông tin và đăng tác phẩm mới]
      ]
    ]
  )
])

// ==========================================
// SLIDE 23: Demo ứng dụng: Đăng chương mới & Kích hoạt AI
// ==========================================
#slide("Demo ứng dụng: Đăng chương mới & Kích hoạt AI", [
  #grid(
    columns: (1fr, 1.2fr),
    gutter: 20pt,
    [
      *Tải lên chương và chạy Pipeline:*
      - Admin nhập số chương, tiêu đề chương và kéo thả danh sách file ảnh truyện gốc.
      - Khi bấm *Bắt đầu xử lý*, Spring Boot nhận ảnh, đẩy payload lên RabbitMQ và trả về trạng thái "Đang xử lý".
      - FastAPI AI Worker xử lý ngầm, cập nhật kết quả qua Webhook.
    ],
    [
      #align(center + horizon)[
        #image("../images/dang_chuong_moi.png", height: 85%)
        #v(-4pt)
        #text(size: 10pt, fill: rgb("#64748b"))[Giao diện đăng tải chương truyện và kích hoạt AI]
      ]
    ]
  )
])

// ==========================================
// SLIDE 24: Đánh giá chất lượng
// ==========================================
#slide("Đánh giá chất lượng", [
  #set text(size: 18pt)
  #grid(
    columns: (1.2fr, 1fr),
    gutter: 15pt,
    [
      *Đo lường định lượng: (CPU i7-12700K, 16GB RAM)*
      - *Thời gian xử lý*: \~16.22s/trang (gồm dịch Gemini API 5-9s, còn lại OCR/Inpaint CPU cục bộ).
      - *Tỷ lệ lỗi ký tự (CER)*: MangaOcr \~6-10%, PaddleOCR \~5-8%.
      
      *Đánh giá định tính:*
      - *LaMa Inpainting*: Tái tạo nền sạch, giữ nguyên screentones Manga.
      - *Gemini 3.1 Flash-Lite*: Dịch tự nhiên, xưng hô chuẩn xác nhờ ngữ cảnh hình ảnh.
    ],
    [
      #align(center + horizon)[
        #image("../images/clean (1).jpg", width: 95%)
        #v(-5pt)
        #text(size: 11pt, style: "italic", fill: rgb("#64748b"))[Ảnh trang truyện đã qua Inpainting, MAD_STONE © Masaki Hidehisa]
      ]
    ]
  )
])

// ==========================================
// SLIDE 25: Kết luận & Hướng phát triển tương lai
// ==========================================
#slide("Kết luận & Hướng phát triển", [
  #text(size: 17pt)[
    #grid(
      columns: (1.1fr, 0.9fr, 1fr),
      gutter: 12pt,
      [
        *Kết quả đạt được:*
        #list(
          [Hoàn thiện hệ thống *ứng dụng đọc truyện tranh* & *AI Pipeline* bất đồng bộ.],
          [Tách biệt dữ liệu ảnh/chữ; hỗ trợ tra từ trực tiếp (*Tap-to-Translate*).],
          [Quy trình test độ tin cậy cao (JUnit 5, JaCoCo, PiTest, pytest).]
        )
      ],
      [
        *Hạn chế tồn tại:*
        #list(
          [Độ trễ xử lý các chương truyện lớn khi tải đồng thời từ nhiều yêu cầu.],
          [Sai số OCR với font viết tay nghệ thuật và nền tranh phức tạp.]
        )
      ],
      [
        *Hướng phát triển:*
        #list(
          [Fine-tune OCR; nâng cấp Inpainting (GAN/Diffusion).],
          [Autoscaling AI Worker trên Cloud (GCP/AWS) qua RabbitMQ.],
          [Phát triển ứng dụng di động & tính năng đọc offline.]
        )
      ]
    )
  ]
])


