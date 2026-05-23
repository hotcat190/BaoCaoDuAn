#import "/global_vars.typ": TTS_implemented

#heading(numbering: none, outlined: true)[Mở đầu]
#counter("is-chương").update(0)

== Đặt vấn đề
Trong kỷ nguyên số hóa, truyện tranh kỹ thuật số đã trở thành một nền tảng giải trí và văn hóa có sức ảnh hưởng toàn cầu, thu hút hàng triệu độc giả ở mọi lứa tuổi. Tuy nhiên, rào cản ngôn ngữ vẫn là một thách thức lớn đối với những người yêu thích truyện tranh muốn tiếp cận sớm nhất các tác phẩm quốc tế hoặc có nhu cầu sử dụng truyện tranh như một công cụ hỗ trợ học ngoại ngữ tự nhiên. Phương pháp dịch thuật thủ công truyền thống thường tiêu tốn nhiều thời gian, phụ thuộc lớn vào các nhóm dịch tự phát và không thể đáp ứng được tính cá nhân hóa trong việc tra cứu tức thì của người đọc.

Sự phát triển mang tính đột phá của Trí tuệ Nhân tạo (AI) trong những năm gần đây, đặc biệt là các mô hình nhận dạng ký tự quang học dựa trên học sâu (Deep Learning-based OCR Model), kỹ thuật xử lý hình ảnh và xóa chữ phục hồi nền (Image Inpainting), cùng khả năng xử lý ngôn ngữ vượt trội của các Mô hình ngôn ngữ lớn (LLM) đã mở ra cơ hội giải quyết bài toán này một cách tự động và tối ưu. Việc xây dựng một hệ thống có khả năng tự động hóa quy trình dịch thuật, đồng thời cung cấp trải nghiệm tương tác thông minh trực tiếp trên giao diện đọc truyện là vô cùng cần thiết. Dự án "Phát triển ứng dụng đọc truyện tranh hỗ trợ đa ngôn ngữ bằng việc ứng dụng AI tự động dịch" được thực hiện nhằm nghiên cứu và cài đặt một giải pháp công nghệ toàn diện, mang lại trải nghiệm đọc liền mạch, đồng thời hỗ trợ tối đa cho việc tiếp cận ngôn ngữ mới của người dùng.

== Mục tiêu và ý nghĩa thực tiễn của dự án
Dự án hướng tới việc thiết kế, xây dựng và triển khai một nền tảng đọc truyện tranh thông minh, ứng dụng các mô hình học sâu để phá bỏ rào cản ngôn ngữ. 

Ý nghĩa thực tiễn của dự án gồm hai khía cạnh cốt lõi:

\- *Đối với người đọc:* Cung cấp một môi trường đọc truyện tương tác cao. Người dùng có thể chạm trực tiếp vào vùng chữ trên hình ảnh để tra cứu từ vựng theo ngữ cảnh#context {
  if TTS_implemented.get() == true [, nghe phát âm chuẩn thông qua công nghệ chuyển đổi văn bản thành giọng nói (TTS)]
} và xem bản dịch hiển thị đè một cách thẩm mỹ lên khung thoại gốc mà không làm ảnh hưởng đến nền tranh bên dưới.

\- *Đối với khâu quản trị và vận hành:* Tự động hóa hoàn toàn quy trình tiền xử lý nội dung khi tải lên chương mới nhờ vào đường ống xử lý (AI Pipeline) hoạt động theo cơ chế hàng chờ bất đồng bộ, giúp tiết kiệm tối đa nguồn lực và thời gian so với quy trình dịch thuật truyền thống.

== Đối tượng nghiên cứu và phạm vi thực hiện
\- *Đối với đối tượng nghiên cứu:* Dự án tập trung tìm hiểu các mô hình học sâu trong thị giác máy tính phục vụ cho tác vụ nhận diện văn bản đồ họa phức tạp (Text Detection/OCR) và xóa chữ trên ảnh (Inpainting); đồng thời nghiên cứu kỹ thuật tối ưu hóa câu lệnh (Prompt Engineering) cho các Mô hình ngôn ngữ lớn (LLM) để đảm bảo bản dịch sát nghĩa và phù hợp với ngữ cảnh truyện tranh.

\- *Đối với phạm vi thực hiện:* Hệ thống được giới hạn xây dựng dưới dạng một ứng dụng Web hoàn chỉnh, bao gồm giao diện tương tác phía người dùng và trang quản trị (Next.js), hệ thống xử lý nghiệp vụ trung tâm (Spring Boot) và dịch vụ xử lý AI chuyên biệt (FastAPI). Hệ thống tập trung tối ưu hóa trải nghiệm đọc trên các định dạng ảnh phổ biến và vận hành ổn định trên môi trường container hóa (Docker).

== Phương pháp nghiên cứu
Dự án kết hợp chặt chẽ giữa nghiên cứu lý thuyết và triển khai thực nghiệm:

\- *Phương pháp nghiên cứu lý thuyết:* Khảo sát các công trình khoa học, tài liệu kỹ thuật liên quan đến xử lý ảnh, thị giác máy tính và xử lý ngôn ngữ tự nhiên; nghiên cứu kiến trúc hệ thống hướng dịch vụ lai (Hybrid - SOA) và cơ chế hàng chờ thông điệp bất đồng bộ để giải quyết bài toán hiệu năng hệ thống.

\- *Phương pháp thực nghiệm:* Cài đặt và tích hợp các mô hình pre-trained chuyên dụng; thực hiện cấu hình kết nối API của các mô hình ngôn ngữ lớn; tiến hành kiểm thử tải và đo lường thời gian phản hồi thực tế của tính năng tương tác AI.

== Bố cục của báo cáo
Nội dung của báo cáo gồm 4 chương:

\- *Chương 1: Cơ sở lý thuyết và công nghệ áp dụng:* Trình bày tổng quan về các định dạng truyện tranh, các giải pháp dịch truyện hiện tại, lý thuyết nền tảng về AI (OCR, Inpainting, LLM), kiến trúc xử lý bất đồng bộ và lý do lựa chọn các công nghệ triển khai (Next.js, Spring Boot, FastAPI, RabbitMQ).

\- *Chương 2: Phân tích yêu cầu hệ thống:* Xác định các tác nhân, xây dựng biểu đồ Use Case tổng quát, đặc tả chi tiết các luồng nghiệp vụ cốt lõi của người dùng và quản trị viên, cùng các yêu cầu phi chức năng về hiệu năng và bảo mật.

\- *Chương 3: Thiết kế kiến trúc hệ thống:* Mô tả kiến trúc tổng thể Hybrid SOA, thiết kế cơ sở dữ liệu quan hệ (ERD), thiết kế chi tiết luồng tiền xử lý AI bất đồng bộ và luồng tương tác Client - Service thông qua các sơ đồ tuần tự (Sequence Diagram).

\- *Chương 4: Cài đặt, triển khai và kiểm thử:* Chi tiết hóa quá trình lập trình, cấu hình môi trường Docker, xây dựng mã nguồn cho các service và tích hợp hệ thống hàng chờ thông điệp để xử lý dữ liệu hình ảnh. Mô tả quá trình kiểm thử chức năng, đảm bảo hệ thống chạy đúng yêu cầu.

