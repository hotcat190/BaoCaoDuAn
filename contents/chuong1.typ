#heading(level: 1, numbering: none)[Chương 1: Cơ sở lý thuyết và công nghệ áp dụng]

#counter(heading).update(1)
#counter("is-chương").update(1)

// 1.1
== Tổng quan về các định dạng truyện tranh

Truyện tranh kỹ thuật số đã phát triển mạnh mẽ và trở thành một phương thức giải trí đại chúng mang tính toàn cầu. Sự đa dạng về nguồn gốc xuất xứ đã hình thành nên ba định dạng thiết kế tiêu biểu nhất hiện nay bao gồm Manga (Nhật Bản), Manhwa (Hàn Quốc), Manhua (Trung Quốc) và Webtoon (truyện tranh kỹ thuật số cuộn dọc). Mỗi định dạng sở hữu những triết lý thiết kế hình ảnh, bố cục khung tranh (panels) và cấu trúc bong bóng thoại (speech bubbles) rất đặc trưng. Việc thấu hiểu các đặc điểm này là điều kiện tiên quyết để xây dựng một đường ống xử lý trí tuệ nhân tạo (AI Pipeline) nhận diện và dịch thuật chính xác.

=== Định dạng Manga (Nhật Bản)
Manga là nền tảng lâu đời nhất trong ba định dạng, mang những quy ước khắt khe về mặt nghệ thuật và bố cục hình ảnh truyền thống:

\- Hướng đọc mặc định: Manga tuân thủ nghiêm ngặt quy tắc đọc từ phải sang trái, từ trên xuống dưới. Điều này ảnh hưởng trực tiếp đến thứ tự logic của các khung thoại và cách người đọc tiếp nhận thông tin.

\- Bố cục trang in (Page-based Layout): Khung tranh của Manga được sắp xếp bất đối xứng, đan xen phức tạp trên một không gian trang giấy cố định. Các khung hình có thể chồng lấp lên nhau, không có ranh giới rõ ràng hoặc sử dụng các kỹ thuật tràn viền (bleed panels) để tăng tính biểu cảm.

\- Đặc trưng khung thoại: Chữ bên trong khung thoại của Manga truyền thống (tiếng Nhật) thường được viết theo chiều dọc. Hệ quả là các bong bóng thoại thường có dạng hình elip đứng hoặc hình chữ nhật thuôn dài theo chiều thẳng đứng. Ngoài ra, Manga sử dụng rất nhiều từ tượng thanh (onomatopoeia) được vẽ trực tiếp lên nền tranh, không nằm trong khung thoại, gây khó khăn lớn cho các tác vụ nhận diện vùng chữ.

#figure(
  image("/images/nekodama_002.jpg"),
  caption: [Layout của một bộ truyện Manga.], 
)
#v(4pt)
#align(center)[#text(12pt)[Ảnh lấy từ Trang 2, Chương 1, Truyện Nekodama © Ebifuray - từ tập dữ liệu Manga109s @manga-109s]]

=== Định dạng Manhwa (Hàn Quốc truyền thống)
Manhwa truyền thống chịu ảnh hưởng lớn từ cấu trúc đồ họa của Manga nhưng có những cải tiến quan trọng để phù hợp với văn hóa đọc hiện đại:

\- Hướng đọc mặc định: Khác với Manga, Manhwa được đọc từ trái sang phải, từ trên xuống dưới theo định dạng cấu trúc văn bản chuẩn quốc tế.

\- Bố cục và màu sắc: Manhwa xuất bản dưới dạng sách in truyền thống thường có bố cục ô tranh vuông vắn và tuần tự hơn Manga. Mặc dù ban đầu chủ yếu là đen trắng, các tác phẩm Manhwa hiện đại khi số hóa đã bắt đầu áp dụng đổ màu kỹ thuật số toàn phần.

\- Đặc trưng khung thoại: Do ngôn ngữ tiếng Hàn hiện đại viết theo chiều ngang, các khung thoại trong Manhwa có xu hướng mở rộng theo chiều ngang (hình elip ngang hoặc hình chữ nhật bo góc). Mật độ chữ trong khung thoại Manhwa thường cao hơn và phân tách rõ ràng hơn so với Manga.

=== Định dạng Manhua (Trung Quốc)
Manhua đại diện cho nền truyện tranh của Trung Quốc, có sự giao thoa mạnh mẽ giữa yếu tố mỹ thuật truyền thống và xu hướng công nghệ số hiện đại:

\- Hướng đọc mặc định: Tương tự như Manhwa, Manhua hiện đại tuân thủ quy tắc đọc từ trái sang phải, từ trên xuống dưới. Tuy nhiên, ở các tác phẩm cổ phong, kiếm hiệp hoặc dã sử, đôi khi thứ tự đọc từ phải sang trái vẫn được áp dụng linh hoạt trong các ô thoại đơn lẻ nhằm tôn trọng thói quen viết chữ Hán truyền thống.

\- Đặc trưng đồ họa và màu sắc: Bản sắc của Manhua nằm ở phong cách đổ màu kỹ thuật số cực kỳ rực rỡ, sắc nét và chi tiết, thường áp dụng các kỹ thuật mô phỏng tranh thủy mặc hoặc nghệ thuật hoạ hình 3D. Các ô tranh trong Manhua có xu hướng kéo dài biên độ cảnh nền (background panoramas) để tạo hiệu ứng không gian hoành tráng, kỳ ảo.

\- Đặc trưng khung thoại: Do đặc thù sử dụng hệ chữ viết biểu ý (chữ Hán), văn bản trong Manhua có độ nén thông tin trên từng ký tự cực kỳ cao. Do đó, các bong bóng thoại thường được thiết kế dạng hình tròn đều hoặc elip nhỏ gọn, phân bổ thưa thoáng và chiếm ít diện tích trang truyện hơn nhằm nhường chỗ cho các chi tiết đồ họa nền phức tạp.

 
=== Định dạng Webtoon (Truyện tranh kỹ thuật số cuộn dọc)
Webtoon là một cuộc cách mạng về hình thức thể hiện truyện tranh, được thiết kế chuyên biệt cho kỷ nguyên điện thoại thông minh và thiết bị di động:

\- Bố cục cuộn dọc vô hạn (Infinite Vertical Scroll): Webtoon hoàn toàn loại bỏ khái niệm "trang giấy" truyền thống. Các ô tranh được sắp xếp nối tiếp nhau theo một trục dọc duy nhất, người đọc trải nghiệm câu chuyện bằng cách cuộn màn hình từ trên xuống dưới.

\- Không gian và khoảng cách: Khoảng cách giữa các ô tranh trong Webtoon rất lớn, thường tạo ra các khoảng trống màu trắng hoặc màu đen để điều tiết nhịp điệu kể chuyện và tâm lý người đọc. Khối lượng hình ảnh trên một đơn vị diện tích hiển thị thấp hơn nhiều so với Manga.

\- Đặc trưng khung thoại: Khung thoại trong Webtoon cực kỳ trực quan, hầu hết sử dụng chữ viết ngang, đổ màu nền bong bóng rõ ràng (thường là màu trắng nguyên bản) và có đường viền sắc nét. Tuy nhiên, do khoảng cách giữa các khung tranh lớn, việc liên kết các khung thoại thuộc cùng một phân cảnh đòi hỏi hệ thống phải xử lý khoảng cách pixel theo trục dọc một cách thông minh thay vì chỉ dựa vào tọa độ cục bộ.

#figure(
  image("/images/msedge_xjHnK9kcWs.png"),
  caption: [Layout của một trang truyện webtoon. 
]
)
#v(4pt)
#align(center)[#text(size: 12pt)[Ảnh chụp từ Chương 1, Comic 어느 날 해츨링이 되었다 (tạm dịch: "Một ngày nọ, tôi biến thành một chú chim non.") của các tác giả 판테라 (Pantela), 리피아 (Lipia), 햄스끼 (Haemseukki), Comic Naver. @webtoon-screenshot]]

=== Đặc thù hiển thị và thách thức trong tác vụ phân tách khung thoại
Từ các đặc điểm cấu trúc trên, tác vụ phân tách khung tranh và nhận diện khung thoại (Panel and Speech Bubble Segmentation) đối mặt với những thách thức kỹ thuật cốt lõi sau:

\- Sự đa dạng về hình học của bong bóng thoại: Khung thoại không chỉ có dạng hình elip chuẩn mà còn biến thể thành hình tia chớp (biểu thị sự tức giận, hét lớn), hình đám mây (suy nghĩ nội tâm), hoặc các khối văn bản tự do không có viền bao quanh. Hệ thống AI phải có khả năng tổng quát hóa cao để không bỏ sót các dạng hình học dị biệt này.

\- Giao thoa giữa văn bản và thực thể đồ họa: Trong truyện tranh, chữ thường xuyên đè lên tóc, trang phục của nhân vật hoặc các chi tiết nền có độ tương phản phức tạp. Việc phân tách không tốt sẽ dẫn đến phân mảnh vùng chữ khi đưa vào mô hình OCR.

\- Quản lý thứ tự đọc (Reading Order Detection): Đây là bài toán phức tạp nhất khi chuyển đổi từ ảnh sang dữ liệu số. Hệ thống không thể áp dụng một thuật toán quét từ trái sang phải cố định, mà phải chia ra thành hai định dạng Manga hay Webtoon để áp dụng mô hình đồ thị (Graph-based) hoặc thuật toán sắp xếp tọa độ phù hợp, đảm bảo luồng dịch thuật diễn ra tự nhiên theo đúng ý đồ của tác giả.

// 1.2.