#heading(numbering: none, outlined: true)[Kết luận]
#counter("is-chương").update(0)
#counter(heading).update(1)

== Kết quả đạt được

Dự án "Phát triển ứng dụng đọc truyện tranh hỗ trợ đa ngôn ngữ bằng việc ứng dụng AI tự động dịch" đã hoàn thành toàn diện các mục tiêu đặt ra ban đầu, xây dựng thành công một hệ thống nền tảng số hóa và dịch thuật truyện tranh tự động hỗ trợ đa ngôn ngữ bằng việc ứng dụng các mô hình học sâu và kiến trúc hướng dịch vụ lai. Các kết quả cụ thể bao gồm:

\- Xây dựng thành công hệ thống AI Pipeline xử lý ảnh truyện tranh bất đồng bộ, tích hợp mô hình YOLO cho phân tách khung tranh (Panel Detection), các kiến trúc học sâu chuyên dụng (MangaOcr, PaddleOCR) cho trích xuất nhận diện chữ văn bản, thuật toán xóa chữ nền Simple-LaMa Inpainting giúp hoàn trả nền tranh tự nhiên, và sử dụng mô hình ngôn ngữ lớn Gemini kết hợp cơ chế Structured Outputs để dịch thuật hàng loạt bám sát ngữ cảnh.

\- Triển khai thành công phân hệ Core Backend bằng Spring Boot 3.5 ứng dụng kiến trúc phân lớp, tích hợp cơ sở dữ liệu PostgreSQL phục vụ lưu trữ quan hệ, ElasticSearch hỗ trợ tìm kiếm toàn văn độ trễ thấp, Redis phối hợp bộ nhớ đệm Caffeine tăng hiệu năng phản hồi API, và RabbitMQ quản lý hàng đợi điều phối thông điệp.

\- Phát triển giao diện người dùng Frontend hiện đại bằng Next.js 16 và Tailwind CSS v4, áp dụng kiến trúc App Router, quản lý trạng thái toàn cục bằng Zustand và đồng bộ hóa dữ liệu thông qua React Query, cung cấp trình xem truyện thông minh và tính năng Tap-to-Translate hỗ trợ người đọc tương tác tra cứu ngôn ngữ thời gian thực.

\- Thiết lập quy trình kiểm thử và đảm bảo chất lượng toàn diện thông qua kiểm thử đơn vị, kiểm thử tích hợp và kiểm thử đột biến (JUnit 5, Mockito, H2 Database, JaCoCo, PiTest cho Backend; pytest cho AI Pipeline), kết hợp công cụ phân tích mã nguồn tĩnh ESLint nhằm kiểm soát nghiêm ngặt độ tin cậy của toàn bộ hệ thống.

== Hạn chế của dự án

Mặc dù đạt được những kết quả khả quan về mặt kiến trúc và công nghệ, hệ thống vẫn tồn tại một số điểm hạn chế nhất định cần tiếp tục nghiên cứu cải tiến:

\- Thời gian xử lý tổng thể của đường ống AI đối với các chương truyện có dung lượng lớn hoặc số lượng trang nhiều đôi khi còn chịu độ trễ nhất định khi chịu tải đồng thời từ nhiều yêu cầu, do chi phí tính toán của các mô hình học sâu và thời gian gọi API dịch thuật bên ngoài.

\- Đối với các trang truyện có phong cách nghệ thuật phức tạp, chữ viết tay nghệ thuật (stylistic fonts) nằm đè lên các chi tiết nền có độ chi tiết cao, các mô hình OCR và Inpainting tiêu chuẩn đôi khi chưa đạt độ chính xác tuyệt đối, đòi hỏi cơ chế hiệu chỉnh thủ công từ phía quản trị viên.

== Hướng phát triển tương lai

Để nâng cao giá trị thực tiễn của dự án, có một số hướng phát triển như:

\- Nghiên cứu tinh chỉnh (Fine-tune) các mô hình OCR nội bộ chuyên biệt cho ngôn ngữ truyện tranh bản địa và tối ưu hóa thuật toán Inpainting mạng sinh đối nghịch (GAN) hoặc Khuếch tán (Diffusion) để xử lý các bố cục đồ họa phức tạp.

\- Triển khai cơ chế co giãn tự động (Autoscaling) các AI Worker container dựa trên độ dài hàng đợi của RabbitMQ trên các hạ tầng điện toán đám mây như Google Cloud Platform hoặc AWS để tối ưu năng lực tính toán và chi phí vận hành.

\- Mở rộng các tính năng nâng cao cho ứng dụng bao gồm chế độ đọc ngoại tuyến (Offline reading support), hệ thống gợi ý truyện thông minh dựa trên hành vi độc giả và phát triển phiên bản ứng dụng di động đa nền tảng sử dụng React Native hoặc Kotlin Jetpack Compose.