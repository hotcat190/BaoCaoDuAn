// #import "@preview/alexandria:0.2.2": *
// #show: alexandria(read: path => read(path))
// #load-bibliography("bibliography.yml")

#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 3cm, left: 3cm, right: 2cm)
)
#show link: underline
#set heading(numbering: "1.1.")
#set text(font: "SVN-Times New Roman", lang: "vi", size: 13pt)
#show heading.where(level: 1): set text(size: 18pt)
#show outline.entry.where(level: 1): set text(weight: "bold")
#set par(
  justify: true,
  first-line-indent: (amount: 1cm, all: true),
  leading: 0.5em
)
#set block(spacing: 6pt)

#include "cover_page.typ"
#pagebreak()
#include "lời_cảm_ơn.typ"
#pagebreak()
#include "lời_cam_đoan.typ"
#pagebreak()

#include "tóm_tắt.typ"

#pagebreak()

#[
  #show heading: set align(center)
  #heading(numbering: none, outlined: false)[Mục lục]
  #outline(title: none)
]

#pagebreak()

#[
  #show heading: set align(center)
  #heading(numbering: none)[Danh mục hình ảnh]
  #outline(title: none, target: figure.where(kind: image))
]

#pagebreak()

#[
  #show heading: set align(center)
  #heading(numbering: none)[Danh mục bảng biểu]
  #outline(title: none, target: figure.where(kind: table))
]

#pagebreak()

#[
  #show heading: set align(center)
  #heading(numbering: none)[Danh mục các từ viết tắt]
  #outline(title: none, target: figure.where(kind: table))
]

#pagebreak()
#set page(numbering: "1", number-align: center + bottom)
#include "mở_đầu.typ"
#link(<bib-phan-dinh-dieu>)[[1]] <cite-phan-dinh-dieu>

#pagebreak()
#heading(numbering: none)[Tài liệu tham khảo]
*Tiếng Việt*

#link(<cite-phan-dinh-dieu>)[\[1\]] Phan Đình Diệu, _Lý thuyết về độ phức tạp tính toán_, Nhà xuất bản Đại học Quốc gia Hà Nội, Hà Nội, 1999, tr. 15-25. <bib-phan-dinh-dieu>
// #context {
//   // 2. Lấy toàn bộ danh sách các tài liệu đã được cite trong bài
//   let (references: bib-refs, ..bib-info) = get-bibliography()

//   // 3. Render danh mục Tiếng Việt
//   strong[Tiếng Việt]
//   render-bibliography(
//     title: none,
//     (
//       // Lọc các tài liệu có key bắt đầu bằng "vi-"
//       references: bib-refs.filter(ref => ref.key.starts-with("vi-")),
//       ..bib-info
//     )
//   )

//   // 4. Render danh mục Tiếng Anh
//   strong[Tiếng Anh]
//   render-bibliography(
//     title: none,
//     (
//       // Lọc các tài liệu có key bắt đầu bằng "en-"
//       references: bib-refs.filter(ref => ref.key.starts-with("en-")),
//       ..bib-info
//     )
//   )
// }