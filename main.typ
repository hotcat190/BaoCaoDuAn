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

#include "frontmatter/cover_page.typ"
#pagebreak()
#include "frontmatter/loi_cam_on.typ"
#pagebreak()
#include "frontmatter/loi_cam_doan.typ"
#pagebreak()
#include "frontmatter/tom_tat.typ"


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
