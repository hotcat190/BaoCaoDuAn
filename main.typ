#set page(
  paper: "a4",
  margin: (top: 2.5cm, bottom: 3cm, left: 3cm, right: 2cm)
)
#set text(font: "SVN-Times New Roman", lang: "vi", size: 13pt)
#show link: underline
#show outline.entry.where(level: 1): set text(weight: "bold")
#set par(
  justify: true,
  first-line-indent: (amount: 1cm, all: true),
  leading: 0.5em
)
#set block(spacing: 6pt)

#set heading(numbering: (..vị_trí) => {
  let các_cấp = vị_trí.pos()
  let là_chương = counter("is-chương").get().at(0) >= 1
  if các_cấp.len() == 1 {
    return none
  } else {
    if là_chương {
      let chỉ_số_chương = counter(heading).get().at(0)
      return numbering("1.1.", chỉ_số_chương, ..các_cấp.slice(1))
    } else {
      return numbering("1.", ..các_cấp.slice(1))
    }
  }
})
#show heading.where(level: 2): mục_lớn => [
  #mục_lớn
  #v(6pt)
]
#show heading.where(level: 1): set text(size: 18pt)

#show table.header: set align(center + horizon)
#set figure(numbering: (..vị_trí) => {
  let các_cấp = counter(heading).get()
  let chương = if các_cấp.len() > 0 { các_cấp.at(0) } else { 1 }
  numbering("1.1", chương, ..vị_trí)
})
#show heading.where(level: 1): it => {
  counter(figure.where(kind: table)).update(0)
  counter(figure.where(kind: image)).update(0)
  it
}

#include "frontmatter/cover_page.typ"
#pagebreak()
#include "frontmatter/loi_cam_on.typ"
#pagebreak()
#include "frontmatter/loi_cam_doan.typ"
#pagebreak()
#include "frontmatter/tom_tat.typ"

#pagebreak()
#include "danh_muc/muc_luc.typ"
#pagebreak()
#include "danh_muc/danh_muc_hinh_anh.typ"
#pagebreak()
#include "danh_muc/danh_muc_bang_bieu.typ"
#pagebreak()
#include "danh_muc/danh_muc_cac_tu_viet_tat.typ"
#pagebreak()

#set page(numbering: "1", number-align: center + bottom)
#include "contents/mo_dau.typ"

#pagebreak()
#include "contents/chuong1.typ"
#pagebreak()
#include "contents/chuong2.typ"
#pagebreak()

#heading(numbering: none)[Tài liệu tham khảo]
#bibliography("bibliography.yml", title: none)

