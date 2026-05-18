#show link: underline
#set heading(numbering: "1.1.")
#set text(font: "SVN-Times New Roman",lang: "vi")
#set par(justify: true)

#include "cover_page.typ"

#pagebreak()

#include "lời_cảm_ơn.typ"

#pagebreak()

#include "lời_cam_đoan.typ"

#pagebreak()

#align(center,[
  #text(18pt)[*Tóm tắt*]
])

#pagebreak()

#[
  #show heading: set align(center)
  #outline(
    title: (text(18pt)[Mục lục])
  )
]

#pagebreak()

#[
  #show heading: set align(center)
  #outline(
    title: (text(18pt)[Danh mục hình ảnh]),
    target: figure.where(kind: image)
  )
]

#pagebreak()

#[
  #show heading: set align(center)
  #outline(
    title: (text(18pt)[Danh mục bảng biểu]),
    target: figure.where(kind: table)
  )
]

#pagebreak()

#[
  #show heading: set align(center)
  #outline(
    title: (text(18pt)[Danh mục các từ viết tắt]),
    target: figure.where(kind: table)
  )
]