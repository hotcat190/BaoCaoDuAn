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
  caption: [Layout của một trang truyện Manga.], 
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
== Các giải pháp dịch truyện tự động hiện tại

Trong những năm gần đây, sự bùng nổ của các mô hình học sâu và cộng đồng mã nguồn mở đã thúc đẩy việc hình thành nhiều giải pháp tự động hóa quy trình số hóa và dịch thuật truyện tranh. Việc phân tích ưu và nhược điểm của các hệ thống đi trước là tiền đề quan trọng để định hình kiến trúc cho dự án này. Các hướng tiếp cận tiêu biểu hiện nay bao gồm:

=== Giải pháp số hóa tương tác (Mokuro kết hợp Yomitan)
Đây là công cụ chuyên dụng cho định dạng Manga Nhật Bản. Mokuro @mokuro thực hiện quét toàn bộ thư mục ảnh truyện, sử dụng mô hình học sâu để phát hiện các khối văn bản (text blocks) và tạo ra một lớp phủ HTML vô hình đè lên ảnh gốc. Khi người dùng đọc truyện trên trình duyệt, họ có thể sử dụng các tiện ích mở rộng như Yomitan @yomitan để kích hoạt tính năng "pop-up từ điển" ngay khi di chuột vào vùng chữ.
#v(3pt)
#pad(left: 1cm)[
  + *Ưu điểm:* Giữ nguyên được 100% đồ họa gốc của tác giả do không cần can thiệp vào nền ảnh, tốc độ xử lý nhanh, hỗ trợ học ngoại ngữ tự nhiên rất tốt.  
  + *Nhược điểm:* Phụ thuộc hoàn toàn vào môi trường trình duyệt máy tính, không tự động dịch nghĩa toàn bộ câu mà chỉ hỗ trợ tra từ đơn hoặc cụm từ, và không tối ưu cho định dạng cuộn dọc của Webtoon.
]

=== Đường ống dịch thuật tự động khép kín (MangaTranslator và Manga/Image Translator)
Đây là các hệ thống xây dựng Pipeline toàn diện từ khâu đầu vào đến đầu ra. Quy trình hoạt động bao gồm: Phát hiện chữ $arrow.r$ Nhận diện ký tự quang học (OCR) $arrow.r$ Đưa qua API dịch thuật (Google Translate, DeepL) $arrow.r$ Xóa chữ cũ bằng thuật thuật toán Inpainting $arrow.r$ Vẽ chữ đã dịch (Typesetting) đè lên vùng ảnh sạch @mangatranslator @manga-image-translator.
#v(3pt)
#pad(left: 1cm)[
  + *Ưu điểm:* Tự động hóa hoàn toàn, người đọc không cần thực hiện bất kỳ thao tác tra cứu nào, hỗ trợ dịch hàng loạt (batch processing) toàn bộ chương truyện.
  + *Nhược điểm:* Thuật toán Typesetting tự động thường căn chỉnh font chữ chưa thẩm mỹ, đôi khi làm tràn chữ ra ngoài khung thoại. Đồng thời, cấu trúc mã nguồn dạng khối (monolithic pipeline) khiến hệ thống khó mở rộng hoặc thay thế linh hoạt từng mô hình AI thành phần.
]

=== Hệ thống dịch thuật tối ưu hiệu năng (Koharu) 
Koharu @koharu là một giải pháp hiện đại ứng dụng Machine Learning, tập trung vào việc tối ưu hóa tốc độ xử lý luồng dịch thuật đồ họa. Dự án này tối ưu hóa việc phân tách các tác vụ xử lý ảnh nặng và kết hợp linh hoạt giữa xử lý cục bộ với các API đám mây.
#v(3pt)
#pad(left: 1cm)[
  + *Ưu điểm:* Cấu trúc mã nguồn tinh gọn, xử lý ngữ cảnh dịch tương đối tốt nhờ việc gom cụm các khung thoại theo phân đoạn logic.
  + *Nhược điểm:* Yêu cầu tài nguyên phần cứng máy chủ có GPU để duy trì độ trễ thấp, giao diện phân phối đến người dùng cuối chưa thực sự trực quan và tiện dụng trên các thiết bị di động.
]
#v(6pt)
Từ các phân tích trên, dự án hướng tới việc kế thừa khả năng xử lý Pipeline khép kín của các giải pháp tự động, nhưng cải tiến bằng cách tách rời các service theo kiến trúc Microservices kết hợp hàng chờ Message Broker nhằm tối ưu hiệu năng tối đa cho môi trường đa nền tảng.

// 1.3
== Công nghệ Trí tuệ Nhân tạo (AI) trong xử lý đa phương tiện

Hệ thống đề xuất sử dụng kết hợp các mô hình học sâu chuyên dụng cho từng tác vụ trong đường ống xử lý hình ảnh và ngôn ngữ, bao gồm ba thành phần cốt lõi.

=== Nhận dạng ký tự quang học (OCR) trên cấu trúc hình ảnh phức tạp
Đối với văn bản nằm trong truyện tranh, các giải pháp OCR thông thường (như Tesseract @tesseract) thường cho kết quả rất kém do chữ có nhiều định dạng nghệ thuật, đổ bóng và nền ảnh phức tạp. Do đó, hệ thống phân tách thành hai nhánh xử lý:

\- Với định dạng Manga (chữ viết dọc, font chữ Nhật đặc thù): Sử dụng mô hình `comic-text-detector` @comic-text-detector để định vị chính xác tọa độ các bounding box của khung thoại, kết hợp với `MangaOcr` @mangaocr – mô hình End-to-End chuyên biệt được tối ưu cho việc nhận diện chữ tiếng Nhật viết dọc.

\- Với định dạng Webtoon (chữ viết ngang, nền màu phức tạp): Sử dụng mô hình `PaddleOCR-v5` @paddleocr nhờ khả năng nhận diện chữ đa hướng (Rotated Text Detection) mạnh mẽ và tốc độ trích xuất chuỗi ký tự tối ưu trên các dòng máy chủ hiệu năng trung bình.

=== Mô hình sinh hình ảnh và kỹ thuật phục hồi nền (Image Inpainting)
Sau khi trích xuất được văn bản gốc, để chuẩn bị không gian chèn chữ dịch mới mà không làm hỏng trải nghiệm thị giác của người đọc, hệ thống áp dụng mô hình mạng học sâu `LaMa` (Large Mask Inpainting) @lama. Mô hình này sử dụng các lớp Fast Fourier Convolution (FFC) cho phép hiểu và khôi phục các kết cấu đồ họa có tần suất lặp lại cao, xóa sạch chữ gốc và tự động bù đắp các chi tiết bối cảnh bị che khuất một cách tự nhiên nhất.

=== Mô hình ngôn ngữ lớn (LLM) trong dịch thuật ngữ cảnh
Thay vì sử dụng các công cụ dịch thuật theo từng dòng thô sơ, hệ thống tích hợp mô hình ngôn ngữ lớn `gemini-3.1-flash-lite` @gemini-flash-lite. Việc ứng dụng LLM cho phép hệ thống truyền kèm siêu dữ liệu (metadata) về ngữ cảnh của chương truyện. Nhờ đó, văn bản dịch đầu ra không bị rời rạc mà giữ được mạch văn văn học, hiểu được các tiếng lóng và phân biệt được đại từ nhân xưng phù hợp với văn hóa Đông Á.

//1.4.
== Tổng quan về các công cụ và framework sử dụng

Để hiện thực hóa đường ống công nghệ phức tạp từ khâu xử lý AI đến giao diện tương tác người dùng, hệ thống được phân rã thành các dịch vụ độc lập, sử dụng các framework tối ưu nhất cho từng tác vụ:

\- *Next.js (Frontend Ecosystem):* Framework phát triển phía Client dựa trên React, hỗ trợ cơ chế render phía máy chủ (SSR/ISR). Đây là lựa chọn cốt lõi để tối ưu hóa tốc độ tải trang truyện, tối ưu SEO cho nền tảng và cung cấp trải nghiệm mượt mà cho Comic Viewer nhờ khả năng preload hình ảnh thông minh. @nextjs

\- *Spring Boot (Core Backend Service):* Nền tảng vững chắc quản trị toàn bộ logic nghiệp vụ hệ thống, quản lý người dùng, phân quyền bảo mật (JWT) và điều phối giao tiếp dữ liệu. Hệ sinh thái mạnh mẽ của Spring giúp đảm bảo tính toàn vẹn dữ liệu ở các luồng nghiệp vụ phức tạp. @springboot

\- *FastAPI (AI Engine Service):* Framework Python có hiệu năng cao, xây dựng trên nền tảng ASGI, hỗ trợ native cơ chế bất đồng bộ (`async/await`). FastAPI đóng vai trò làm cổng giao tiếp API cho các mô hình máy học (OCR, LaMa), giúp giảm thiểu tối đa overhead khi truyền tải dữ liệu hình ảnh nhị phân dung lượng lớn. @fastapi

\- *PostgreSQL (Relational Database):* Hệ quản trị cơ sở dữ liệu quan hệ được chọn để lưu trữ các thông tin có tính cấu trúc chặt chẽ như tài khoản người dùng, cấu trúc phân cấp Truyện - Chương, lịch sử đọc truyện và hệ thống cấu hình. @postgresql

\- *Minio (Object Storage):* Hệ thống lưu trữ đối tượng mã nguồn mở, tương thích hoàn toàn với chuẩn S3 API. Minio được tự triển khai (self-hosted) trên hạ tầng của dự án để quản lý tập trung toàn bộ tài nguyên hình ảnh gốc, ảnh sạch sau inpainting và các tệp siêu dữ liệu JSON. @minio

\- *ElasticSearch (Advanced Search Engine):* Công cụ tìm kiếm phân tán dựa trên nền tảng Lucene, được tích hợp vào hệ thống nhằm xử lý các truy vấn tìm kiếm truyện nâng cao, hỗ trợ tìm kiếm mờ (fuzzy search), tự động gợi ý (auto-complete) và phân tích ngữ nghĩa tên truyện đa ngôn ngữ với độ trễ tính bằng miligiây. @elasticsearch

\- *Redis (High-Speed Caching):* Lớp lưu trữ dữ liệu trên bộ nhớ RAM, được sử dụng để tối ưu tốc độ truy xuất các thông tin có tần suất đọc cao như tiến trình đọc của người dùng, bảng xếp hạng truyện và quản lý cơ chế giới hạn tần suất gọi API (Rate Limiting). @redis

//1.5.
== Kiến trúc Microservices và Xử lý bất đồng bộ

Từ việc lựa chọn các công nghệ chuyên biệt nêu trên, bài toán đặt ra là làm thế nào để các thành phần này giao tiếp với nhau hiệu quả mà không gây ảnh hưởng đến trải nghiệm người đọc. Trong một hệ thống ứng dụng công nghệ học sâu quy mô lớn, việc tổ chức kiến trúc phần mềm đóng vai trò quyết định đến độ ổn định và khả năng mở rộng. 

Quy trình xử lý một chương truyện tải lên bao gồm chuỗi các tác vụ nặng: giải nén và chuẩn hóa hình ảnh, chạy mô hình phát hiện và nhận diện văn bản (OCR), thực hiện xóa chữ khôi phục nền (Inpainting), và gọi API mô hình ngôn ngữ lớn (LLM) để dịch thuật theo ngữ cảnh. Các tác vụ AI này tiêu tốn rất nhiều tài nguyên tính toán của CPU/GPU và có độ trễ lớn (thường mất từ vài giây đến hàng chục giây cho một trang truyện chất lượng cao). Nếu hệ thống vận hành theo cơ chế giao tiếp đồng bộ truyền thống (Synchronous), máy chủ quản trị sẽ rơi vào trạng thái nghẽn cổ chai (Bottleneck), dẫn đến cạn kiệt tài nguyên xử lý request và gây ra lỗi quá hạn thời gian phản hồi (HTTP Timeout). Do đó, hệ thống áp dụng kiến trúc Microservices kết hợp cơ chế xử lý bất đồng bộ thông qua hàng chờ thông điệp (Message Broker).

=== Bài toán nút thắt cổ chai (Bottleneck) trong xử lý tác vụ AI đồng bộ
Trong mô hình giao tiếp đồng bộ HTTP RESTful truyền thống, khi Quản trị viên (Admin) tải lên một chương truyện mới có dung lượng hàng chục megabyte với hàng trăm trang ảnh, luồng xử lý sẽ diễn ra tuần tự:

\- Client gửi request tải chương truyện lên Core Backend.

\- Core Backend tiếp nhận, lưu trữ ảnh gốc, sau đó gọi trực tiếp dịch vụ AI Backend.

\- Core Backend phải giữ kết nối HTTP ở trạng thái chờ (blocking) trong suốt thời gian AI Backend xử lý OCR, Inpainting và dịch thuật cho từng trang ảnh một cách tuần tự.

Hệ quả kỹ thuật của quy trình đồng bộ này vô cùng nghiêm trọng:
#v(3pt)
#pad(left: 1.5cm)[
  + *Nghẽn luồng xử lý (Thread Starvation):* Máy chủ Backend sẽ bị cạn kiệt luồng xử lý (Thread Pool) do phải giữ quá nhiều kết nối mở ngầm chỉ để chờ phản hồi từ các mô hình AI. Điều này khiến hệ thống không thể tiếp nhận thêm bất kỳ yêu cầu nào khác từ phía người đọc thông thường, làm giảm nghiêm trọng tính sẵn sàng (Availability) của toàn bộ ứng dụng.
  + *Lỗi Timeout kết nối:* Do thời gian xử lý AI vượt quá cấu hình timeout mặc định của các cổng mạng (Gateway) hoặc trình duyệt (thường là 30 giây đến 2 phút), kết nối sẽ bị ngắt giữa chừng, dẫn đến việc upload thất bại dù dữ liệu có thể đang được xử lý ở ngầm phía sau.
  + *Khả năng chịu lỗi kém (Single Point of Failure):* Nếu dịch vụ AI gặp sự cố ngắt kết nối hoặc quá tải, lỗi xử lý sẽ lan truyền ngược lại Core Backend, gây sập toàn bộ luồng nghiệp vụ quản lý nội dung truyện.
]

=== Giải pháp xử lý bất đồng bộ với Message Broker (RabbitMQ)
Để triệt tiêu nút thắt cổ chai nêu trên, hệ thống thực hiện tách rời hoàn toàn (Decoupling) luồng nghiệp vụ lưu trữ truyện và luồng xử lý trí tuệ nhân tạo bằng cách tích hợp RabbitMQ @rabbitmq làm hệ thống trung gian điều phối thông điệp hoạt động theo cơ chế bất đồng bộ (Asynchronous Processing).

Quy trình hoạt động và tư tưởng cốt lõi của giải pháp bất đồng bộ này được tổ chức như sau:

\- *Giai đoạn tiếp nhận phi tập trung:* Khi Admin gửi yêu cầu upload chương truyện, Core Backend (Spring Boot) chỉ thực hiện các tác vụ kiểm tra hợp lệ cơ bản, ghi nhận thông tin chương vào cơ sở dữ liệu PostgreSQL và đẩy tệp ảnh gốc vào phân vùng lưu trữ Minio.

\- *Giai đoạn đóng gói và gửi thông điệp:* Ngay sau khi ảnh gốc được lưu trữ thành công, Core Backend tạo ra một thông điệp (Message Payload) dạng JSON chứa các thông tin định danh cốt lõi như `chapter_id`, `page_id`, `image_url` (đường dẫn đến ảnh truyện lưu trên Minio), `original_lang` (ngôn ngữ gốc của bộ truyện) và `target_langs` (danh sách các ngôn ngữ đích). Thông điệp này được gửi trực tiếp đến một Exchange cấu hình trong RabbitMQ với độ trễ cực thấp (dưới vài miligiây). Sau khi gửi thông điệp thành công, Core Backend lập tức trả về phản hồi HTTP 201 (Created) cho giao diện Admin kèm trạng thái chương là "Đang xử lý". Quản trị viên có thể tiếp tục thực hiện các thao tác khác mà không cần treo màn hình chờ đợi.

\- *Giai đoạn định tuyến và hàng chờ ổn định:* RabbitMQ tiếp nhận thông điệp tại Exchange, dựa trên quy tắc định tuyến (Routing Key) để đẩy thông điệp vào một hàng chờ cố định (Queue). Hàng chờ này đóng vai trò như một bộ đệm lưu trữ an toàn. Nếu số lượng chương tải lên tăng đột biến, hàng chờ sẽ tự động phình to để tích lũy các tác vụ mà không gây áp lực trực tiếp lên năng lực tính toán của các Worker AI.

\- *Giai đoạn tiêu thụ và xử lý phân tán:* Dịch vụ AI Backend (FastAPI) đóng vai trò là một Consumer (Worker) kết nối ngầm với RabbitMQ Queue. Worker sẽ chủ động kéo thông điệp về xử lý theo năng lực thực tế của phần cứng (Pull-based mechanism). Tại đây, Pipeline AI (OCR, Inpainting, Translation) sẽ được thực thi độc lập. Khi hoàn tất tác vụ xử lý cho một chương truyện, AI Worker sẽ lưu tệp JSON metadata cùng ảnh sạch vào Minio, cập nhật trạng thái chương thành "Hoàn thành" trong cơ sở dữ liệu và gửi một tín hiệu xác nhận (Acknowledge - ACK) lại cho RabbitMQ để xóa bỏ thông điệp khỏi hàng chờ.

Bằng việc áp dụng cơ chế điều phối thông điệp bất đồng bộ của RabbitMQ, hệ thống đạt được tính năng co giãn tải tự động (Load Leveling / Throttling), bảo vệ các dịch vụ AI khỏi nguy cơ quá tải, đồng thời giải phóng hoàn toàn năng lực xử lý của Core Backend, đảm bảo trải nghiệm liền mạch cho cả người vận hành lẫn độc giả đọc truyện.