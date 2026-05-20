#import "/global_vars.typ": TTS_implemented, vertical_scroll_implemented
#heading(level: 1, numbering: none)[Chương 2: Phân tích yêu cầu hệ thống]

#counter(heading).update(2)

#show table: set align(left)
#show figure: set block(breakable: true)

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

\- *Đối với nhà vận hành phân phối:* Việc quản lý nội dung đa ngôn ngữ trở thành một gánh nặng hạ tầng lưu trữ lớn. Nếu một nền tảng muốn hỗ trợ đồng thời ba ngôn ngữ (ví dụ: tiếng Việt, tiếng Anh, tiếng Trung), hệ thống bắt buộc phải lưu trữ ba bộ tệp hình ảnh hoàn toàn độc lập cho cùng một chương truyện. Điều này làm nhân ba chi phí băng thông truyền tải và dung lượng lưu trữ, gây lãng phí tài nguyên và khó khăn cho khâu đồng bộ phiên bản.

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

\- *Độc giả hệ thống (Registered User):* Là người dùng đã hoàn tất quy trình khởi tạo tài khoản và được hệ thống xác thực thông tin mã khóa. Bên cạnh việc kế thừa toàn bộ năng lực tương tác của độc giả vãng lai, tác nhân này được hệ thống mở rộng các phân hệ tính năng cá nhân hóa chuyên sâu, bao gồm: quản lý tủ sách cá nhân, lưu trữ tự động tiến trình và vị trí đọc thời gian thực, gửi bình luận và tương tác cộng đồng.

\- *Quản trị viên (Administrator):* Là nhân sự vận hành có đặc quyền cao nhất, chịu trách nhiệm quản lý toàn bộ vòng đời của nội dung truyện và giám sát hạ tầng kỹ thuật. Quyền hạn của tác nhân này bao gồm: quản trị danh mục dữ liệu, thực hiện tải lên các tập tin hình ảnh chương mới, kích hoạt và kiểm soát luồng hoạt động của đường ống tiền xử lý dữ liệu AI Pipeline. Ngoài ra, Quản trị viên còn nắm giữ vai trò điều phối cấu hình tài nguyên hệ thống, kiểm duyệt nội dung đóng góp và theo dõi các chỉ số hiệu năng vận hành thông qua bảng điều khiển trung tâm.

== Biểu đồ Use Case tổng quát

Sau khi tiến hành phân rã chức năng hệ thống dựa trên phạm vi quyền hạn của từng tác nhân đã xác định, các yêu cầu chức năng thực tế của hệ thống được tổng hợp thành ba phân hệ chính dưới đây. Danh sách này tập trung phản ánh các Use Case đã được thiết kế và cài đặt thực tế trong ứng dụng nhằm đảm bảo tính tinh gọn và tối ưu hóa đường ống xử lý.

=== Phân hệ Đọc truyện và Tương tác AI
\- *UC_01:* Xem danh sách và tìm kiếm truyện

\- *UC_02:* Đọc truyện

\- *UC_03:* Tra từ vựng qua ảnh

=== Phân hệ Quản lý tài khoản và Cá nhân hóa
\- *UC_04:* Đăng ký tài khoản mới

\- *UC_05:* Đăng nhập và Đăng xuất

\- *UC_06:* Quản lý tủ sách cá nhân

\- *UC_07:* Lưu vị trí đọc tự động

\- *UC_08:* Gửi bình luận và tương tác cộng đồng

=== Phân hệ Quản trị nội dung và Vận hành AI Pipeline
\- *UC_09:* Quản lý danh mục và thông tin cấu trúc truyện

\- *UC_10:* Tải lên chương truyện mới và kích hoạt đường ống tiền xử lý AI (OCR, Inpainting, LLM Translation)

#[
  #show figure: set block(width: 73%)
  #show figure: set align(center)
  #figure(
    image("/images/use_case.svg"),
    caption: [Biểu đồ Use Case tổng quát hệ thống],
  )
]

== Đặc tả các Use Case cốt lõi

Để đặc tả chi tiết và chuẩn hóa các yêu cầu chức năng, báo cáo áp dụng cấu trúc Bảng đặc tả Use Case (Use Case Tables) kế thừa theo phương pháp luận kiến trúc phần mềm hiện đại. @use-case-table

Mỗi cấu trúc Use Case trong phân hệ sẽ được chuẩn hóa đồng bộ theo cấu trúc bảng hai cột tiêu chuẩn bao gồm các thuộc tính cụ thể: Mã Use Case, Tiêu đề, Tác nhân chính, Mô tả, Tiền điều kiện, Tác nhân kích hoạt, Luồng xử lý chính, Luồng rẽ nhánh, Luồng ngoại lệ, Hậu điều kiện, Tài liệu liên quan, Ghi chú.

=== Phân hệ Đọc truyện và Tương tác AI

==== UC_01: Xem danh sách và tìm kiếm truyện

#set par(first-line-indent: 0cm)

#figure(
  kind: table,
  caption: [UC_01 - Xem danh sách và tìm kiếm truyện],  
  table(
    columns: (1fr, 3fr),
    fill: (col, row) => if col == 0 { rgb("#f0f4f8") } else { none },
    stroke: 1pt,
    [Mã Use Case], [UC_01],
    [Tiêu đề], [Xem danh sách và tìm kiếm truyện],
    [Tác nhân chính], [Khách truy cập, Độc giả hệ thống],
    [Mô tả], [Cho phép người dùng duyệt danh mục các tác phẩm hiện có trên hệ thống hoặc tìm kiếm truyện nhanh dựa theo các từ khóa và bộ lọc phân loại.],
    [Tiền điều kiện], [
      1. Hệ thống ở trạng thái hoạt động ổn định.
      2. Cơ sở dữ liệu danh mục các tác phẩm truyện tranh đã được thiết lập sẵn trên hệ thống.
    ],
    [Tác nhân kích hoạt], [Người dùng truy cập vào giao diện trang chủ hoặc nhập dữ liệu vào thanh tìm kiếm.],
    [Luồng xử lý chính], [
      1. Người dùng truy cập vào trang chủ hoặc trang danh mục của ứng dụng.
      2. Hệ thống tiếp nhận yêu cầu và hiển thị danh sách các tác phẩm mới cập nhật, truyện thịnh hành cùng danh mục phân loại.
      3. Người dùng nhập từ khóa tìm kiếm vào thanh tìm kiếm.
      4. Hệ thống thực hiện tìm kiếm, phân tích dữ liệu dựa trên từ khóa người dùng đã nhập.
      5. Hệ thống kết xuất kết quả và hiển thị danh sách các tác phẩm phù hợp lên giao diện người dùng.
    ],
    [Luồng rẽ nhánh], [
      Không có.
    ],
    [Luồng ngoại lệ], [
      *Tại bước 4 - Không tìm thấy kết quả phù hợp:*
      1. Hệ thống xác định không có tác phẩm nào trùng khớp với các tiêu chí tìm kiếm của người dùng.
      2. Thanh tìm kiếm hiển thị: "Không tìm thấy tác phẩm phù hợp".
      #v(6pt)
      *Tại bước 4 - Lỗi kết nối dữ liệu:*
      1. Hệ thống mất kết nối đến phân vùng lưu trữ thông tin danh mục.
      2. Hệ thống hiển thị thông báo lỗi: "Dịch vụ tìm kiếm hiện đang bận, vui lòng thử lại sau".
    ],
    [Hậu điều kiện], [
      1. Danh sách các tác phẩm truyện tranh được cập nhật hiển thị chính xác theo yêu cầu tương tác hoặc tìm kiếm của người dùng.
    ],
    [Tài liệu liên quan], [Không có.],
    [Ghi chú], [Không có.]
  )  
)

==== UC_02: Đọc truyện

#figure(
  kind: table,
  caption: [UC_02 - Đọc truyện],
  table(
    columns: (1fr, 3fr),
    fill: (col, row) => if col == 0 { rgb("#f0f4f8") } else { none },
    stroke: 1pt,
    [Mã Use Case], [UC_02],
    [Tiêu đề], [Đọc truyện],
    [Tác nhân chính], [Khách truy cập, Độc giả hệ thống],
    [Mô tả], [Cung cấp giao diện đọc truyện chuyên dụng, hỗ trợ hiển thị hình ảnh chương truyện linh hoạt theo cơ chế lật trang hoặc cuộn dọc, đồng thời cho phép tùy chỉnh giao diện màu sắc để tối ưu hóa trải nghiệm đọc.],
    [Tiền điều kiện], [
      1. Người dùng đang ở giao diện thông tin chi tiết của một bộ truyện cụ thể.
      2. Chương truyện được lựa chọn đã có sẵn dữ liệu hình ảnh được cấu hình hợp lệ trên hệ thống.
    ],
    [Tác nhân kích hoạt], [Người dùng nhấn chọn vào một chương truyện cụ thể từ danh sách chương.],
    [Luồng xử lý chính], [
      1. Người dùng nhấn chọn một chương truyện cụ thể từ danh sách chương của bộ truyện.
      2. Hệ thống tiếp nhận yêu cầu, thực hiện tải tài nguyên hình ảnh của chương truyện và dữ liệu cấu trúc đi kèm.
      3. Hệ thống kết xuất và hiển thị giao diện trình xem truyện với nội dung các trang ảnh#context{if vertical_scroll_implemented.get() == true [ được sắp xếp tự động theo định dạng mặc định của tác phẩm (cuộn dọc đối với Webtoon hoặc lật trang đối với Manga)]}.
      4. Người dùng thực hiện thao tác #context{if vertical_scroll_implemented.get() == true [cuộn màn hình hoặc]} lật trang để tiến hành theo dõi nội dung truyện tranh.
      5. Hệ thống hiển thị các hình ảnh tiếp theo tương ứng.
    ],
    [Luồng rẽ nhánh], [
      *Tại bước 4 - Người dùng thay đổi chế độ giao diện nền:*
      1. Người dùng nhấn vào biểu tượng cấu hình hiển thị trên thanh công cụ của trình xem truyện.
      2. Hệ thống thay đổi màu sắc chủ đạo của giao diện trình xem tương ứng với tùy chọn.
    ],
    [Luồng ngoại lệ], [
      *Tại bước 2 - Lỗi tải tài nguyên hình ảnh chương truyện:*
      1. Hệ thống mất kết nối đến phân vùng lưu trữ tệp hình ảnh hoặc tài nguyên bị lỗi.
      2. Hệ thống hiển thị thông báo lỗi trên màn hình trình xem: "Không thể tải nội dung chương truyện, vui lòng thử lại sau".
    ],
    [Hậu điều kiện], [
      1. Giao diện trình xem truyện hoạt động bình thường, hiển thị đầy đủ hình ảnh nội dung chương truyện theo các tùy chỉnh tương tác của người dùng.
    ],
    [Tài liệu liên quan], [Không có.],
    [Ghi chú], [Không có.]
  )
)

==== UC_03: Tra từ vựng qua ảnh

#figure(
  kind: table,
  caption: [UC_03 - Tra từ vựng qua ảnh],
  table(
    columns: (1fr, 3fr),
    fill: (col, row) => if col == 0 { rgb("#f0f4f8") } else { none },
    stroke: 1pt,
    [Mã Use Case], [UC_03],
    [Tiêu đề], [Tra từ vựng qua ảnh],
    [Tác nhân chính], [Khách truy cập, Độc giả hệ thống],
    [Mô tả], [Cho phép người dùng chọn hoặc chạm trực tiếp vào một vùng văn bản trên trang truyện để hệ thống tự động nhận diện và hiển thị cửa sổ nhỏ giải nghĩa theo ngữ cảnh ngữ văn.],
    [Tiền điều kiện], [
      1. Người dùng đang ở trong giao diện trình xem truyện (UC_02).
      2. Trang truyện đang xem chứa các phân vùng văn bản ngôn ngữ gốc được thiết lập hợp lệ trên hệ thống.
    ],
    [Tác nhân kích hoạt], [Người dùng thực hiện thao tác chạm hoặc nhấn chọn vào một vùng chữ hoặc khối thoại trên trang truyện.],
    [Luồng xử lý chính], [
      1. Người dùng chạm vào vùng văn bản cần tra cứu ý nghĩa trên trang truyện.
      2. Hệ thống ghi nhận tọa độ điểm tương tác, tự động xác định phân vùng văn bản tương ứng và hiển thị hiệu ứng để làm nổi bật khối chữ được chọn.
      3. Hệ thống tiến hành trích xuất nội dung văn bản gốc và truy xuất nghĩa dịch phù hợp theo ngữ cảnh của phân đoạn truyện hiện tại.
      4. Hệ thống kết xuất và hiển thị một cửa sổ nhỏ ngay tại vị trí người dùng vừa tương tác, bao gồm nội dung chữ gốc, phiên âm và nghĩa dịch tương ứng.
    ],
    [Luồng rẽ nhánh], [
      *Tại bước 4 - Người dùng đóng cửa sổ giải nghĩa:*
      1. Người dùng chạm vào vùng trống bất kỳ nằm ngoài vùng hiển thị của cửa sổ hoặc nhấn vào nút đóng trên thanh công cụ nhỏ.
      2. Hệ thống ẩn cửa sổ giải nghĩa, đồng thời gỡ bỏ hiệu ứng khối văn bản trên ảnh truyện.
    ],
    [Luồng ngoại lệ], [
      *Tại bước 2 - Người dùng tương tác vào vùng trống không chứa văn bản:*
      1. Hệ thống phân tích tọa độ vị trí tương tác và xác định điểm chạm không nằm trong bất kỳ phân vùng chữ nào.
      2. Hệ thống không thực hiện hành động, giữ nguyên trạng thái giao diện và luồng đọc truyện của người dùng.
      
      #v(3pt)
  
      *Tại bước 3 - Lỗi trích xuất dữ liệu dịch thuật:*
      1. Hệ thống gặp sự cố kết nối nội bộ hoặc không tìm thấy dữ liệu giải nghĩa tương thích với phân vùng chữ được chọn.
      2. Hệ thống hiển thị thông báo lỗi ngắn gọn ngay bên trong cửa sổ nhỏ: "Không thể tải dữ liệu dịch thuật cho vùng văn bản này".
    ],
    [Hậu điều kiện], [
      1. Cửa sổ giải nghĩa được hiển thị chính xác hoặc được đóng lại hoàn toàn theo ý muốn của người dùng, trả giao diện về trạng thái đọc truyện thông thường.
    ],
    [Tài liệu liên quan], [Không có.],
    [Ghi chú], [Không có.]
  )
)

=== Phân hệ Quản lý tài khoản và Cá nhân hóa

==== UC_04: Đăng ký tài khoản mới
#figure(
  kind: table,
  caption: [UC_04 - Đăng ký tài khoản mới],
  table(
    columns: (1fr, 3fr),
    fill: (col, row) => if col == 0 { rgb("#f0f4f8") } else { none },
    stroke: 1pt,
    [Mã Use Case], [UC_04],
    [Tiêu đề], [Đăng ký tài khoản mới],
    [Tác nhân chính], [Khách truy cập],
    [Mô tả], [Cho phép người dùng khởi tạo một tài khoản thành viên mới bằng cách cung cấp các thông tin định danh cá nhân, tạo cơ sở để truy cập vào các phân hệ chức năng cá nhân hóa nâng cao.],
    [Tiền điều kiện], [
      1. Người dùng đang truy cập ứng dụng ở trạng thái chưa đăng nhập tài khoản hệ thống.
    ],
    [Tác nhân kích hoạt], [Người dùng nhấn chọn chức năng "Đăng ký" trên thanh điều hướng hoặc giao diện ứng dụng.],
    [Luồng xử lý chính], [
      1. Người dùng nhấn chọn nút chức năng đăng ký tài khoản trên giao diện người dùng.
      2. Hệ thống tiếp nhận yêu cầu, kết xuất và hiển thị biểu mẫu đăng ký thành viên bao gồm tên người dùng, địa chỉ thư điện tử và mật khẩu bảo mật.
      3. Người dùng nhập đầy đủ các thông tin theo yêu cầu của biểu mẫu và nhấn nút xác nhận gửi dữ liệu.
      4. Hệ thống thực hiện kiểm tra tính hợp lệ của dữ liệu (cấu trúc địa chỉ thư điện tử, độ dài mật khẩu) và đối chiếu tính duy nhất của thông tin trên toàn hệ thống.
      5. Hệ thống khởi tạo hồ sơ tài khoản mới, lưu trữ thông tin an toàn và gửi thông báo xác nhận đăng ký thành công cho người dùng.
      6. Hệ thống tự động điều hướng người dùng về giao diện đăng nhập hệ thống.
    ],
    [Luồng rẽ nhánh], [
      *Tại bước 3 - Người dùng lựa chọn đăng ký bằng tài khoản Google:*
      1. Người dùng nhấn chọn biểu tượng hoặc nút chức năng "Đăng ký bằng Google".
      2. Hệ thống thực hiện chuyển hướng màn hình giao diện sang trang xác thực quyền truy cập chính thức của phía đối tác bên thứ ba (Google).
      3. Người dùng tiến hành đăng nhập tài khoản Google và xác nhận đồng ý cung cấp các quyền chia sẻ thông tin cơ bản bao gồm địa chỉ thư điện tử và ảnh đại diện.
      4. Hệ thống tiếp nhận thông tin phản hồi xác thực an toàn từ phía đối tác, tự động trích xuất các trường dữ liệu cần thiết để đồng bộ và cấu hình hồ sơ tài khoản mới trên hệ thống.
      5. Hệ thống gửi thông báo khởi tạo tài khoản thành công và tự động đăng nhập, điều hướng người dùng về trang chủ của ứng dụng.
    ],
    [Luồng ngoại lệ], [
      *Tại bước 4 - Dữ liệu nhập vào sai quy chuẩn hoặc thiếu:*
      1. Hệ thống phát hiện thông tin người dùng cung cấp không thỏa mãn các điều kiện định dạng bắt buộc.
      2. Hệ thống hiển thị các cảnh báo lỗi tương ứng trực tiếp dưới các trường dữ liệu sai và yêu cầu người dùng hiệu chỉnh.
      #v(3pt)
      *Tại bước 4 - Tài khoản đăng ký đã tồn tại:*
      1. Hệ thống đối chiếu dữ liệu và xác định địa chỉ thư điện tử hoặc tên người dùng được nhập đã được đăng ký trước đó.
      2. Hệ thống hiển thị thông báo lỗi trên biểu mẫu: "Địa chỉ thư điện tử hoặc tên người dùng đã tồn tại trên hệ thống".
    ],
    [Hậu điều kiện], [
      1. Một tài khoản thành viên mới được khởi tạo thành công ở trạng thái kích hoạt, sẵn sàng cho các thao tác xác thực quyền hạn tiếp theo.
    ],
    [Tài liệu liên quan], [Không có.],
    [Ghi chú], [Không có.]
  )
)

==== UC_05: Đăng nhập và Đăng xuất
#figure(
  kind: table,
  caption: [UC_05 - Đăng nhập và Đăng xuất],
  table(
    columns: (1fr, 3fr),
    fill: (col, row) => if col == 0 { rgb("#f0f4f8") } else { none },
    stroke: 1pt,
    [Mã Use Case], [UC_05],
    [Tiêu đề], [Đăng nhập và Đăng xuất],
    [Tác nhân chính], [Khách truy cập, Độc giả hệ thống, Quản trị viên],
    [Mô tả], [Xác thực danh tính của người dùng để cấp quyền truy cập vào các tính năng thuộc phân quyền hệ thống tương ứng hoặc kết thúc phiên làm việc an toàn.],
    [Tiền điều kiện], [
      1. Hệ thống ở trạng thái hoạt động ổn định.
      2. Đối với chức năng Đăng nhập: Người dùng đang ở trạng thái chưa đăng nhập và đã có tài khoản hợp lệ trên hệ thống.
      3. Đối với chức năng Đăng xuất: Người dùng đang ở trạng thái đã đăng nhập vào hệ thống.
    ],
    [Tác nhân kích hoạt], [Người dùng nhấn chọn chức năng "Đăng nhập" hoặc "Đăng xuất" trên giao diện ứng dụng.],
    [Luồng xử lý chính], [
      1. Người dùng nhấn chọn chức năng "Đăng nhập" trên giao diện ứng dụng.
      2. Hệ thống tiếp nhận yêu cầu, hiển thị biểu mẫu đăng nhập yêu cầu cung cấp thông tin tài khoản và mật khẩu bảo mật.
      3. Người dùng điền đầy đủ thông tin tài khoản, mật khẩu và nhấn chọn nút xác nhận đăng nhập.
      4. Hệ thống thực hiện tiếp nhận, kiểm tra tính hợp lệ và tiến hành xác thực thông tin đối chiếu với dữ liệu người dùng đã lưu trữ.
      5. Hệ thống xác thực thành công, ghi nhận trạng thái đăng nhập và điều hướng người dùng về giao diện trang chủ theo đúng phân quyền vai trò tương ứng.
    ],
    [Luồng rẽ nhánh], [
      *Tại bước 2 - Người dùng lựa chọn đăng nhập bằng tài khoản Google:*
      1. Người dùng nhấn chọn nút chức năng "Đăng nhập bằng Google".
      2. Hệ thống thực hiện chuyển hướng màn hình sang trang xác thực của đối tác bên thứ ba (Google).
      3. Người dùng tiến hành xác nhận quyền đăng nhập trên giao diện của đối tác.
      4. Hệ thống tiếp nhận thông tin phản hồi xác thực an toàn, kiểm tra liên kết tài khoản và tự động đăng nhập cho người dùng.
      #v(6pt)
      *Tại trạng thái đã đăng nhập - Người dùng thực hiện đăng xuất:*
      1. Người dùng nhấn chọn nút chức năng "Đăng xuất" trên thanh điều hướng hoặc menu cá nhân.
      2. Hệ thống tiếp nhận yêu cầu, tiến hành hủy bỏ phiên làm việc hiện tại và xóa trạng thái xác thực của tài khoản.
      3. Hệ thống gửi thông báo đăng xuất thành công và tự động điều hướng người dùng quay trở lại trang chủ ở trạng thái khách truy cập.
    ],
    [Luồng ngoại lệ], [
      *Tại bước 4 - Thông tin xác thực không chính xác:*
      1. Hệ thống đối chiếu dữ liệu và xác định thông tin tài khoản không tồn tại hoặc mật khẩu không trùng khớp.
      2. Hệ thống hiển thị thông báo lỗi trên biểu mẫu: "Thông tin tài khoản hoặc mật khẩu không chính xác".
    ],
    [Hậu điều kiện], [
      1. Người dùng được chuyển sang trạng thái đã đăng nhập với phân quyền vai trò tương ứng, hoặc quay về trạng thái khách truy cập sau khi đăng xuất thành công.
    ],
    [Tài liệu liên quan], [Không có.],
    [Ghi chú], [Không có.]
  )
)

==== UC_06: Quản lý tủ sách cá nhân
#figure(
  kind: table,
  caption: [UC_06 - Quản lý tủ sách cá nhân],
  table(
    columns: (1fr, 3fr),
    fill: (col, row) => if col == 0 { rgb("#f0f4f8") } else { none },
    stroke: 1pt,
    [Mã Use Case], [UC_06],
    [Tiêu đề], [Quản lý tủ sách cá nhân],
    [Tác nhân chính], [Độc giả hệ thống],
    [Mô tả], [Cho phép người dùng lưu trữ, theo dõi và quản lý danh sách các bộ truyện yêu thích hoặc các bộ truyện đang theo dõi để thuận tiện cho việc truy cập và phân loại về sau.],
    [Tiền điều kiện], [
      1. Người dùng đã đăng nhập thành công vào tài khoản hệ thống (UC_05).
    ],
    [Tác nhân kích hoạt], [Người dùng tương tác với nút chức năng thêm truyện vào tủ sách hoặc bấm chọn truy cập vào giao diện quản lý tủ sách cá nhân.],
    [Luồng xử lý chính], [
      1. Người dùng truy cập vào trang thông tin chi tiết của một tác phẩm truyện tranh cụ thể.
      2. Hệ thống kiểm tra trạng thái lưu trữ của tác phẩm đối với tài khoản hiện tại và hiển thị tùy chọn "Thêm vào tủ sách".
      3. Người dùng nhấn chọn nút "Thêm vào tủ sách".
      4. Hệ thống tiếp nhận yêu cầu, cập nhật thông tin liên kết giữa tài khoản người dùng và tác phẩm vào danh sách lưu trữ cá nhân.
      5. Hệ thống cập nhật lại trạng thái nút thành "Đã lưu vào tủ sách" và gửi thông báo: "Đã thêm truyện vào tủ sách cá nhân thành công".
    ],
    [Luồng rẽ nhánh], [
      *Tại bước 1 luồng chính - Người dùng xem danh sách tủ sách cá nhân:*
      1. Người dùng nhấn chọn mục chức năng "Tủ sách cá nhân" trên thanh điều hướng giao diện.
      2. Hệ thống tiếp nhận yêu cầu, tìm kiếm và truy xuất toàn bộ danh sách các tác phẩm đã được tài khoản này lưu trữ.
      3. Hệ thống kết xuất giao diện và hiển thị đầy đủ danh sách các bộ truyện kèm theo thông tin chương mới nhất của từng bộ để người dùng theo dõi.
      #v(6pt)
      *Tại trang quản lý tủ sách - Người dùng gỡ truyện khỏi tủ sách:*
      1. Người dùng nhấn chọn biểu tượng "Hủy lưu" tại một bộ truyện cụ thể trong danh sách tủ sách cá nhân (hoặc nhấn nút "Hủy lưu" ngay tại trang chi tiết truyện).
      2. Hệ thống tiếp nhận yêu cầu, tiến hành loại bỏ liên kết của tác phẩm này khỏi danh sách lưu trữ của tài khoản.
      3. Hệ thống cập nhật lại danh sách hiển thị, xóa bộ truyện vừa chọn khỏi màn hình tủ sách và gửi thông báo: "Đã xóa truyện khỏi tủ sách".
    ],
    [Luồng ngoại lệ], [
      *Tại bước 4 luồng chính hoặc bước 2 luồng rẽ nhánh - Lỗi đồng bộ dữ liệu:*
      1. Hệ thống gặp sự cố ngắt kết nối đến phân vùng cơ sở dữ liệu lưu trữ thông tin cá nhân.
      2. Hệ thống giữ nguyên trạng thái giao diện cũ và hiển thị thông báo lỗi: "Thao tác thất bại, hệ thống đang bận. Vui lòng thử lại sau".
    ],
    [Hậu điều kiện], [
      1. Danh sách lưu trữ cá nhân của người dùng được cập nhật chính xác (thêm hoặc xóa tác phẩm tương ứng) và được đồng bộ hóa đồng nhất trên tài khoản.
    ],
    [Tài liệu liên quan], [Không có.],
    [Ghi chú], [Không có.]
  )
)

==== UC_07: Lưu vị trí đọc tự động
#figure(
  kind: table,
  caption: [UC_07 - Lưu vị trí đọc tự động],
  table(
    columns: (1fr, 3fr),
    fill: (col, row) => if col == 0 { rgb("#f0f4f8") } else { none },
    stroke: 1pt,
    [Mã Use Case], [UC_07],
    [Tiêu đề], [Lưu vị trí đọc tự động],
    [Tác nhân chính], [Độc giả hệ thống],
    [Mô tả], [Tự động ghi nhận, cập nhật và đồng bộ hóa tiến độ đọc truyện (bao gồm chương hiện tại và vị trí trang ảnh đang dừng lại) của người dùng vào tài khoản cá nhân, giúp họ tiếp tục đọc dễ dàng ở lần truy cập sau.],
    [Tiền điều kiện], [
      1. Người dùng đã đăng nhập thành công vào tài khoản hệ thống (UC_05).
      2. Người dùng đang mở một chương truyện cụ thể trong giao diện trình xem truyện (UC_02).
    ],
    [Tác nhân kích hoạt], [Người dùng thực hiện thao tác tương tác đọc truyện (cuộn màn hình hoặc chuyển sang trang ảnh mới).],
    [Luồng xử lý chính], [
      1. Người dùng thực hiện thao tác cuộn màn hình hoặc chuyển sang trang tiếp theo khi đang đọc truyện.
      2. Hệ thống tự động xác định thông số tiến trình hiện tại bao gồm mã định danh chương truyện và số thứ tự trang ảnh mà người dùng đang dừng lại.
      3. Hệ thống tự động cập nhật và lưu trữ thông tin tiến độ đọc mới này vào hồ sơ lịch sử của tài khoản cá nhân một cách tuần tự.
      4. Hệ thống ghi nhận trạng thái đồng bộ thành công ngầm mà không làm gián đoạn hay ảnh hưởng đến trải nghiệm theo dõi truyện của người dùng.
    ],
    [Luồng rẽ nhánh], [
      *Tại bước 1 luồng chính - Người dùng quay lại đọc tiếp một bộ truyện đang dang dở:*
      1. Người dùng truy cập lại vào một tác phẩm đã đọc trước đó từ danh sách lịch sử hoặc nhấn nút "Đọc tiếp" tại trang thông tin truyện.
      2. Hệ thống tự động tìm kiếm và truy xuất dữ liệu về vị trí đọc được lưu trữ gần nhất của tài khoản đối với tác phẩm này.
      3. Hệ thống tự động điều hướng màn hình người dùng thẳng đến chương truyện và tọa độ trang ảnh đang đọc dở trước đó.
    ],
    [Luồng ngoại lệ], [
      *Tại bước 3 luồng chính - Lỗi mất kết nối mạng tạm thời:*
      1. Hệ thống phát hiện đường truyền Internet của thiết bị người dùng bị ngắt quãng, không thể gửi dữ liệu đồng bộ về máy chủ trung tâm.
      2. Hệ thống tạm thời lưu giữ thông tin vị trí đọc hiện tại vào bộ nhớ tạm cục bộ của thiết bị.
      3. Hệ thống sẽ tự động thực hiện đồng bộ lại dữ liệu này lên tài khoản máy chủ ngay khi phát hiện kết nối mạng được khôi phục ổn định.
    ],
    [Hậu điều kiện], [
      1. Vị trí tiến độ đọc của người dùng được cập nhật chính xác trên hệ thống, sẵn sàng phục vụ cho việc khôi phục trạng thái đọc trên bất kỳ thiết bị nào sau khi đăng nhập.
    ],
    [Tài liệu liên quan], [Không có.],
    [Ghi chú], [Không có.]
  )
)

==== UC_08: Gửi bình luận
#figure(
  kind: table,
  caption: [UC_08 - Gửi bình luận],
  table(
    columns: (1fr, 3fr),
    fill: (col, row) => if col == 0 { rgb("#f0f4f8") } else { none },
    stroke: 1pt,
    [Mã Use Case], [UC_08],
    [Tiêu đề], [Gửi bình luận],
    [Tác nhân chính], [Độc giả hệ thống],
    [Mô tả], [Cho phép người dùng gửi nhận xét và thảo luận trực tiếp về nội dung của chương truyện đang theo dõi, góp phần gia tăng tính tương tác cộng đồng.],
    [Tiền điều kiện], [
      1. Người dùng đã đăng nhập thành công vào tài khoản hệ thống (UC_05).
      2. Người dùng đang ở giao diện trình xem truyện (UC_02) của một chương truyện cụ thể.
    ],
    [Tác nhân kích hoạt], [Người dùng nhập nội dung văn bản và nhấn chọn nút gửi tại vùng bình luận dưới chương truyện.],
    [Luồng xử lý chính], [
      1. Người dùng di chuyển đến khu vực thảo luận nằm phía dưới nội dung chương truyện.
      2. Hệ thống tiếp nhận yêu cầu, tự động tải và hiển thị danh sách các bình luận hiện có của chương truyện đó.
      3. Người dùng nhập nội dung ý kiến hoặc nhận xét vào ô nhập liệu văn bản.
      4. Người dùng nhấn chọn nút gửi bình luận.
      5. Hệ thống tiếp nhận dữ liệu, thực hiện kiểm tra tính hợp lệ của nội dung văn bản (kiểm tra độ dài ký tự và khoảng trống).
      6. Hệ thống lưu trữ thông tin bình luận mới liên kết với hồ sơ tài khoản, cập nhật danh sách hiển thị và thông báo gửi thành công.
    ],
    [Luồng rẽ nhánh], [
      Không có.
    ],
    [Luồng ngoại lệ], [
      *Tại bước 5 - Nội dung nhập vào trống hoặc không hợp lệ:*
      1. Hệ thống kiểm tra dữ liệu đầu vào và phát hiện vùng nhập liệu không chứa ký tự hoặc chỉ chứa các khoảng trắng trống.
      2. Hệ thống tự động vô hiệu hóa nút đăng bình luận trên giao diện để ngăn chặn thao tác gửi dữ liệu trống và dừng luồng xử lý.
      #v(6pt)
      *Tại bước 6 - Lỗi kết nối hệ thống:*
      1. Hệ thống gặp sự cố mất kết nối mạng hoặc không thể đồng bộ thông tin mới vào phân vùng dữ liệu.
      2. Hệ thống giữ nguyên nội dung văn bản người dùng đang nhập để tránh mất mát dữ liệu và hiển thị thông báo lỗi: "Không thể gửi bình luận, hệ thống đang bận. Vui lòng thử lại sau".
    ],
    [Hậu điều kiện], [
      1. Nội dung bình luận của người dùng được lưu trữ thành công trên hệ thống và hiển thị công khai tại khu vực thảo luận dưới chương truyện.
    ],
    [Tài liệu liên quan], [Không có.],
    [Ghi chú], [Không có.]
  )
)
=== Phân hệ Quản trị nội dung và Vận hành AI Pipeline

==== UC_09: Quản lý danh mục truyện
#figure(
  kind: table,
  caption: [UC_09 - Quản lý danh mục và thông tin cấu trúc truyện],
  table(
    columns: (1fr, 3fr),
    fill: (col, row) => if col == 0 { rgb("#f0f4f8") } else { none },
    stroke: 1pt,
    [Mã Use Case], [UC_09],
    [Tiêu đề], [Quản lý danh mục và thông tin cấu trúc truyện],
    [Tác nhân chính], [Quản trị viên],
    [Mô tả], [Cho phép Quản trị viên thực hiện các tác vụ thêm mới, hiệu chỉnh thông tin tổng quan của các bộ truyện và thiết lập sơ đồ cấu trúc phân cấp dữ liệu cho tác phẩm trên hệ thống.],
    [Tiền điều kiện], [
      1. Tài khoản của Quản trị viên đã được xác thực thành công và được cấp đặc quyền truy cập tương ứng trên hệ thống (UC_05).
      2. Quản trị viên đang ở giao diện của không gian làm việc quản trị nội dung.
    ],
    [Tác nhân kích hoạt], [Quản trị viên nhấn chọn các nút chức năng khởi tạo hoặc chỉnh sửa tác phẩm trên thanh công cụ quản lý.],
    [Luồng xử lý chính], [
      1. Quản trị viên truy cập vào trang danh mục tác phẩm và nhấn chọn chức năng "Thêm truyện mới".
      2. Hệ thống tiếp nhận yêu cầu, kết xuất và hiển thị biểu mẫu nhập thông tin tổng quan của bộ truyện bao gồm: tên tác phẩm, tác giả, thể loại phân loại, ngôn ngữ gốc, trạng thái phát hành, nội dung mô tả tóm tắt và trường tải tệp ảnh bìa.
      3. Quản trị viên điền đầy đủ thông tin vào các trường dữ liệu, tiến hành chọn tệp hình ảnh đại diện từ thiết bị và nhấn nút xác nhận "Lưu trữ".
      4. Hệ thống tiếp nhận gói dữ liệu, thực hiện kiểm tra tính hợp lệ của thông tin văn bản đầu vào và cấu trúc tệp hình ảnh đại diện.
      5. Hệ thống khởi tạo không gian lưu trữ dữ liệu gốc cho bộ truyện, ghi nhận cấu trúc thông tin tổng quan vừa tạo và gửi thông báo: "Khởi tạo tác phẩm mới thành công".
      6. Hệ thống tự động cập nhật danh sách quản lý chung và chuyển hướng giao diện về màn hình hiển thị chi tiết của bộ truyện vừa tạo.
    ],
    [Luồng rẽ nhánh], [
      *Tại bước 1 luồng chính - Quản trị viên hiệu chỉnh thông tin bộ truyện hiện có:*
      1. Quản trị viên tìm kiếm bộ truyện cần sửa đổi trong danh sách danh mục và nhấn chọn nút chức năng "Chỉnh sửa".
      2. Hệ thống truy xuất thông tin tổng quan hiện tại của tác phẩm đó và điền tự động dữ liệu vào các trường tương ứng trên biểu mẫu hiệu chỉnh.
      3. Quản trị viên tiến hành thay đổi các nội dung thông tin hoặc cập nhật lại ảnh bìa mới, sau đó nhấn nút xác nhận "Cập nhật".
      4. Hệ thống kiểm tra tính hợp lệ của dữ liệu mới, tiến hành ghi đè thông tin thay đổi vào hệ thống dữ liệu toàn cục và gửi thông báo: "Cập nhật thông tin tác phẩm thành công".
    ],
    [Luồng ngoại lệ], [
      *Tại bước 4 luồng chính hoặc bước 4 luồng rẽ nhánh - Thông tin nhập vào thiếu hoặc sai định dạng:*
      1. Hệ thống phát hiện các trường dữ liệu bắt buộc bị bỏ trống.
      2. Hệ thống giữ nguyên các thông tin đã nhập trên biểu mẫu, đưa ra cảnh báo lỗi trực quan dưới các trường dữ liệu tương ứng để Quản trị viên hiệu chỉnh.
    ],
    [Hậu điều kiện], [
      1. Cấu trúc thông tin dữ liệu tổng quan của bộ truyện được khởi tạo mới hoặc cập nhật thay đổi thành công, sẵn sàng cho các thao tác quản lý chương truyện tiếp theo.
    ],
    [Tài liệu liên quan], [Không có.],
    [Ghi chú], [Không có.]
  )
)

==== UC_10: Tải lên chương truyện mới và kích hoạt đường ống tiền xử lý AI
#figure(
  kind: table,
  caption: [UC_10 - Tải lên chương truyện mới và kích hoạt đường ống tiền xử lý AI],
  table(
    columns: (1fr, 3fr),
    fill: (col, row) => if col == 0 { rgb("#f0f4f8") } else { none },
    stroke: 1pt,
    [Mã Use Case], [UC_10],
    [Tiêu đề], [Tải lên chương truyện mới và kích hoạt đường ống tiền xử lý AI],
    [Tác nhân chính], [Quản trị viên],
    [Mô tả], [Cho phép Quản trị viên tải lên tập hợp các tệp hình ảnh của một chương truyện mới.],
    [Tiền điều kiện], [
      1. Tài khoản của Quản trị viên đã được xác thực thành công và được cấp đặc quyền truy cập tương ứng trên hệ thống (UC_05).
      2. Bộ truyện liên quan đã được khởi tạo thành công cấu trúc thông tin tổng quan trong danh mục hệ thống (UC_09).
      3. Quản trị viên đang ở không gian quản trị giao diện chi tiết của bộ truyện đó.
    ],
    [Tác nhân kích hoạt], [Quản trị viên hoàn tất nhập liệu biểu mẫu thông tin chương, chọn danh sách ảnh và nhấn nút xác nhận bắt đầu xử lý.],
    [Luồng xử lý chính], [
      1. Quản trị viên nhấn chọn nút chức năng "Thêm chương mới" tại giao diện quản lý chi tiết cấu trúc của tác phẩm.
      2. Hệ thống tiếp nhận yêu cầu, hiển thị biểu mẫu bao gồm số thứ tự chương, tên chương, và vùng chọn tải lên tập hợp các tệp hình ảnh truyện.
      3. Quản trị viên điền đầy đủ thông tin định danh chương, tiến hành tải danh sách trang ảnh từ thiết bị và nhấn nút xác nhận "Bắt đầu xử lý".
      4. Hệ thống tiếp nhận gói dữ liệu, kiểm tra tính hợp lệ đầu vào (định dạng tệp ảnh cho phép, tính duy nhất của số chương trong bộ truyện) và tiến hành lưu trữ an toàn toàn bộ các tệp hình ảnh gốc vào phân vùng lưu trữ đối tượng tập trung.
      5. Hệ thống tự động đóng gói thông tin định danh chương, danh sách đường dẫn ảnh gốc và cấu hình đích ngôn ngữ thành một gói tin siêu dữ liệu nghiệp vụ, sau đó đẩy trực tiếp gói tin này vào hệ thống hàng chờ điều phối thông điệp bất đồng bộ.
      6. Hệ thống thiết lập trạng thái vận hành của chương truyện mới là "Đang xử lý", gửi thông báo xác nhận tiếp nhận tác vụ thành công, đồng thời tự động điều hướng giao diện màn hình quay trở lại trang danh sách chương để giải phóng luồng thao tác của Quản trị viên.
    ],
    [Luồng rẽ nhánh], [
      Không có.
    ],
    [Luồng ngoại lệ], [
      *Tại bước 4 - Số thứ tự chương bị trùng lặp hoặc tệp ảnh không đúng định dạng:*
      1. Hệ thống đối chiếu dữ liệu hiện tại và phát hiện số thứ tự chương truyện đã tồn tại trong hệ thống phân cấp của bộ truyện, hoặc có tệp dữ liệu không thỏa mãn quy chuẩn hình ảnh số hóa.
      2. Hệ thống dừng luồng xử lý, giữ nguyên danh mục các tệp và thông tin đã chọn trên biểu mẫu, đồng thời hiển thị cảnh báo lỗi chi tiết để Quản trị viên hiệu chỉnh.
      #v(6pt)
      *Tại bước 5 - Sự cố mất kết nối hạ tầng lưu trữ hoặc dịch vụ điều phối hàng chờ:*
      1. Hệ thống phát hiện sự cố ngắt kết nối mạng nội bộ đến không gian lưu trữ hoặc dịch vụ hàng chờ trung gian bị quá hạn thời gian phản hồi.
      2. Hệ thống hủy bỏ toàn bộ tiến trình ghi nhận tệp, giữ nguyên trạng thái biểu mẫu hiện tại và hiển thị thông báo lỗi hệ thống: "Dịch vụ tiền xử lý hiện tại đang bận, vui lòng thực hiện lại sau".
    ],
    [Hậu điều kiện], [
      1. Chương truyện mới được khởi tạo ở trạng thái "Đang xử lý", tài nguyên ảnh thô được lưu trữ an toàn và gói tin tác vụ được định tuyến thành công vào hàng chờ ổn định, sẵn sàng chờ các Worker dịch vụ trí tuệ nhân tạo chủ động kéo dữ liệu về thực thi độc lập ngầm.
    ],
    [Tài liệu liên quan], [Không có.],
    [Ghi chú], [Không có.]
  )
)

== Các yêu cầu phi chức năng

Bên cạnh các yêu cầu chức năng cốt lõi được mô tả qua hệ thống Use Case, các yêu cầu phi chức năng (Non-functional Requirements) đóng vai trò then chốt trong việc định hình chất lượng dịch vụ, độ ổn định, an toàn thông tin và trải nghiệm tổng thể của người dùng khi vận hành ứng dụng thực tế.

=== Yêu cầu về hiệu năng

\- *Thời gian phản hồi tương tác AI:* Đối với tác vụ tương tác thời gian thực của độc giả như Tra từ vựng qua ảnh (Tap-to-Translate), thời gian từ lúc người dùng chạm vào vùng chữ cho đến khi hệ thống hiển thị cửa sổ giải nghĩa phải đạt độ trễ thấp, với mục tiêu thời gian phản hồi trung bình dưới 1.5 giây trong điều kiện kết nối mạng tiêu chuẩn.

\- *Hiệu năng kết xuất giao diện:* Giao diện trình xem truyện (Comic Viewer) phải đảm bảo thời gian tải và hiển thị trang ảnh nền sạch cùng lớp chữ phủ đè dưới 1 giây đối với các trang tiếp theo nhờ cơ chế tải trước (preload) hình ảnh thông minh.

\- *Khả năng chịu tải và phân tách tác vụ:* Nhờ cơ chế hàng chờ điều phối bất đồng bộ, luồng tải lên chương truyện nặng của Quản trị viên không được gây ảnh hưởng hay làm tăng độ trễ truy cập của độc giả. Hệ thống dịch vụ cốt lõi luôn duy trì tỷ lệ phản hồi yêu cầu thông thường dưới 500 miligiây.

=== Yêu cầu về bảo mật (Security Requirements)

\- *Xác thực và phân quyền tài nguyên:* Hệ thống bắt buộc phải áp dụng cơ chế mã hóa xác thực an toàn mã thông báo dạng chuỗi ký tự (Token) cho mọi kết nối yêu cầu quyền thành viên hoặc quản trị. Hệ thống phân quyền dựa trên vai trò (Role-based Access Control) để cô lập tuyệt đối các cổng lập trình nghiệp vụ của Quản trị viên, ngăn chặn các hành vi truy cập trái phép từ phía máy khách.

\- *An toàn dữ liệu truyền tải:* Toàn bộ dữ liệu trao đổi giữa ứng dụng phía người dùng và các dịch vụ máy chủ phải được mã hóa truyền tải qua các giao thức mạng bảo mật mã hóa tiêu chuẩn nhằm chống lại các nguy cơ đánh cắp thông tin trên đường truyền.

\- *Kiểm soát dữ liệu đầu vào:* Hệ thống phải thực hiện lọc và chuẩn hóa toàn bộ dữ liệu văn bản do người dùng nhập vào (đặc biệt là tính năng gửi bình luận) để triệt tiêu hoàn toàn các nguy cơ tấn công chèn mã độc.