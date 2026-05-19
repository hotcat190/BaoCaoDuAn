#import "/global_vars.typ": TTS_implemented
#heading(level: 1, numbering: none)[Chương 2: Phân tích yêu cầu hệ thống]

#counter(heading).update(2)

// 2.1.
== Phân tích hiện trạng và bài toán đặt ra

=== Hiện trạng quy trình số hóa và dịch thuật truyện tranh kỹ thuật số
Nền công nghiệp truyện tranh kỹ thuật số quốc tế (Manga, Manhwa, Manhua) đang trải qua sự tăng trưởng vượt bậc về số lượng tác phẩm và quy mô độc giả toàn cầu. Tuy nhiên, quy trình biên dịch và phân phối nội dung đa ngôn ngữ hiện nay vẫn phụ thuộc phần lớn vào phương pháp thủ công truyền thống (thường được gọi là scanlation) @scanlation. Quy trình này bao gồm chuỗi các bước biệt lập: thu thập tài nguyên ảnh thô (raw images), sử dụng các công cụ chỉnh sửa đồ họa chuyên dụng như Adobe Photoshop để xóa chữ gốc (cleaning), dịch thuật nội dung thô, và tiến hành chèn thủ công văn bản đã dịch trở lại khung thoại (typesetting).

Quy trình thủ công này tồn tại nhiều vấn đề bất cập:

\- *Chi phí thời gian và nhân lực lớn:* Việc làm sạch nền ảnh và căn chỉnh từng khối chữ thủ công đòi hỏi kỹ năng đồ họa cao và tiêu tốn nhiều giờ làm việc cho mỗi chương truyện. Điều này tạo nên độ trễ lớn (từ vài ngày đến vài tuần) giữa thời điểm phát hành tác phẩm tại quốc gia gốc và thời điểm tiếp cận độc giả quốc tế.

\- *Chất lượng không đồng đều:* Do phụ thuộc vào năng lực chủ quan của các nhóm dịch tự phát, độ chính xác của bản dịch lẫn tính thẩm mỹ của việc sắp đặt font chữ thường biến động mạnh, không có một quy chuẩn kỹ thuật đồng nhất.

\- *Đóng gói dữ liệu tĩnh (Hardcoded Text):* Văn bản dịch sau khi chèn thủ công sẽ bị hòa trộn và xuất ra dưới dạng các điểm ảnh (pixels) cố định trên ảnh nền. Cách làm này triệt tiêu hoàn toàn tính linh hoạt của dữ liệu số, khiến văn bản không còn khả năng tương tác hay chuyển đổi ngôn ngữ linh hoạt.

=== Giới hạn trải nghiệm của độc giả và nhà vận hành hệ thống
Sự bế tắc của việc đóng gói dữ liệu tĩnh ở quy trình truyền thống đã đặt ra những giới hạn nghiêm trọng cho cả hai nhóm đối tượng thụ hưởng:

\- *Đối với độc giả:* Người đọc hoàn toàn ở trạng thái thụ động khi tiếp nhận nội dung. Khi gặp các từ ngữ chuyên ngành, thuật ngữ cổ phong hoặc tiếng lóng cổ ngữ, độc giả không thể thực hiện bất kỳ thao tác tương tác trực tiếp nào để tra cứu ngữ nghĩa. Đối với nhóm người dùng đọc truyện kết hợp học ngoại ngữ, việc văn bản bị nhúng trực tiếp vào hình ảnh khiến họ không thể tra cách phát âm, không thể sao chép chuỗi ký tự hay đối chiếu trực tiếp với ngôn ngữ gốc để hiểu sâu sắc ngữ cảnh văn học.

\- *Đối với nhà vận hành phân phối:* Việc quản lý nội dung đa ngôn ngữ trở thành một gánh nặng hạ tầng lưu trữ lớn. Nếu một nền tảng muốn hỗ trợ đồng thời ba ngôn ngữ (ví dụ: tiếng Việt, tiếng Anh, tiếng Trung), hệ thống bắt buộc phải lưu trữ ba bộ tệp hình ảnh hoàn toàn độc lập cho cùng một chương truyện. Điều này làm nhân ba chi phí băng thông truyền tải (Network Bandwidth) và dung lượng lưu trữ (Storage Capacity), gây lãng phí tài nguyên và khó khăn cho khâu đồng bộ phiên bản.

=== Bài toán đặt ra đối với việc phát triển hệ thống đọc truyện thông minh tích hợp AI
Từ những phân tích hiện trạng sâu sắc trên, dự án này định vị mục tiêu phân tách triệt để giữa tầng hiển thị đồ họa nền và tầng hiển thị thông tin văn bản. Thay vì xem một trang truyện tranh là một bức ảnh phẳng bất biến, hệ thống cần số hóa cấu trúc của trang truyện thành một mô hình dữ liệu động gồm hai thành phần tách biệt: ảnh nền sạch dữ liệu chữ và tệp siêu dữ liệu chứa tọa độ cấu trúc khung thoại cùng nội dung dịch của các ngôn ngữ mục tiêu.

Để hiện thực hóa tư tưởng này, hệ thống phải giải quyết ba bài toán kỹ thuật cốt lõi sau:

\- *Tự động hóa toàn diện đường ống xử lý hình ảnh:* Thay thế quy trình cleaning và typesetting thủ công bằng một Pipeline AI bất đồng bộ, có khả năng tự động nhận diện vùng chữ trên các cấu trúc đồ họa phức tạp, xóa chữ gốc để trả lại ảnh nền sạch và dịch thuật ngữ cảnh bằng trí tuệ nhân tạo một cách tự động.

\- *Xây dựng cơ chế tương tác thời gian thực:* Phát triển một Comic Viewer thông minh trên nền tảng Web, có khả năng render động các lớp chữ (Text Layers) đè lên ảnh nền sạch dựa trên dữ liệu tọa độ pixel đã phân tích. Lớp phủ này phải hỗ trợ chuyển đổi ngôn ngữ tức thì, cho phép nhấn/chạm để tra cứu ngữ nghĩa ngữ cảnh (Tap-to-Translate)#context {
  if TTS_implemented.get() == true [ và tích hợp các tính năng tương tác nâng cao như chuyển đổi văn bản thành giọng nói (TTS)]}.

\- *Tối ưu hạ tầng lưu trữ và khả năng co giãn tải:* Hệ thống chỉ cần lưu trữ duy nhất một tệp ảnh nền sạch và một tệp siêu dữ liệu JSON gọn nhẹ cho nhiều ngôn ngữ khác nhau. Đồng thời, cấu trúc phần mềm phải đảm bảo luồng tải tệp nặng của nhà quản trị vận hành theo cơ chế hàng chờ xử lý phân tán, không gây nghẽn mạch hoặc ảnh hưởng đến trải nghiệm đọc truyện liên tục của độc giả.

// 2.2.
== Xác định các tác nhân (Actors)

Trong giai đoạn phân tích yêu cầu chức năng, việc xác định chính xác các tác nhân (Actors) là bước đi tiên quyết nhằm vạch rõ phạm vi tương tác và phân định quyền hạn xử lý thông tin trong hệ thống. Tác nhân đại diện cho các thực thể bên ngoài (có thể là con người hoặc hệ thống tự động liên kết) trực tiếp tham gia vào việc vận hành hoặc thụ hưởng các dịch vụ dữ liệu do hệ thống cung cấp. Đối với hệ thống ứng dụng đọc truyện tranh thông minh tích hợp AI, các tác nhân được phân tách thành ba nhóm chính dựa trên vai trò nghiệp vụ và cấp độ bảo mật xác thực:

\- *Khách truy cập (Guest):* Là người dùng truy cập vào hệ thống qua giao diện Web công cộng mà chưa thực hiện quy trình đăng ký hoặc đăng nhập tài khoản. Tác nhân này đại diện cho nhóm độc giả đại chúng với nhu cầu trải nghiệm nhanh dịch vụ. Quyền hạn của khách truy cập được giới hạn ở các tương tác đọc truyện cơ bản, tìm kiếm tác phẩm qua thanh công cụ, và trải nghiệm thử tính năng tương tác AI (Tap-to-Translate) trong phạm vi các chương truyện miễn phí được cấu hình sẵn nhằm đảm bảo an toàn tài nguyên API của hệ thống.

\- *Độc giả hệ thống (Registered User):* Là người dùng đã hoàn tất quy trình khởi tạo tài khoản và được hệ thống xác thực thông tin mã khóa (thông qua cơ chế JWT/OAuth2). Bên cạnh việc kế thừa toàn bộ năng lực tương tác của độc giả vãng lai, tác nhân này được hệ thống mở rộng các phân hệ tính năng cá nhân hóa chuyên sâu, bao gồm: quản lý tủ sách cá nhân (Bookmark), lưu trữ tự động tiến trình và vị trí đọc thời gian thực (Reading History), gửi bình luận và tương tác cộng đồng.

\- *Quản trị viên (Administrator):* Là nhân sự vận hành có đặc quyền cao nhất, chịu trách nhiệm quản lý toàn bộ vòng đời của nội dung truyện và giám sát hạ tầng kỹ thuật. Quyền hạn của tác nhân này bao gồm: quản trị danh mục dữ liệu, thực hiện tải lên (upload) các tập tin hình ảnh chương mới, kích hoạt và kiểm soát luồng hoạt động của đường ống tiền xử lý dữ liệu AI Pipeline (OCR, Inpainting, và LLM Translation). Ngoài ra, Quản trị viên còn nắm giữ vai trò điều phối cấu hình tài nguyên hệ thống, kiểm duyệt nội dung đóng góp và theo dõi các chỉ số hiệu năng vận hành thông qua bảng điều khiển trung tâm.

== Biểu đồ Use Case tổng quát

Sau khi tiến hành phân rã chức năng hệ thống dựa trên phạm vi quyền hạn của từng tác nhân đã xác định, các yêu cầu chức năng thực tế của hệ thống được tổng hợp thành ba phân hệ chính dưới đây. Danh sách này tập trung phản ánh các Use Case đã được thiết kế và cài đặt thực tế trong ứng dụng nhằm đảm bảo tính tinh gọn và tối ưu hóa đường ống xử lý.

=== Phân hệ Đọc truyện và Tương tác AI
\- *UC_01:* Xem danh sách và tìm kiếm truyện

\- *UC_02:* Đọc truyện (Comic Viewer)

\- *UC_03:* Tra từ vựng qua ảnh (Tap-to-Translate)

=== Phân hệ Quản lý tài khoản và Cá nhân hóa
\- *UC_04:* Đăng ký tài khoản mới

\- *UC_05:* Đăng nhập và Đăng xuất (Xác thực hệ thống qua cơ chế JWT/OAuth2)

\- *UC_06:* Quản lý tủ sách cá nhân (Bookmark)

\- *UC_07:* Lưu vị trí đọc tự động (Reading History)

\- *UC_08:* Gửi bình luận và tương tác cộng đồng

=== Phân hệ Quản trị nội dung và Vận hành AI Pipeline
\- *UC_09:* Quản lý danh mục và thông tin cấu trúc truyện

\- *UC_10:* Tải lên chương truyện mới và kích hoạt đường ống tiền xử lý AI (OCR, Inpainting, LLM Translation)

#figure(
  image("/images/use_case.svg"),
  caption: [Biểu đồ Use Case tổng quát hệ thống]
)
