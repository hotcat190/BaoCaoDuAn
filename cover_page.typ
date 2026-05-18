#set page(
  margin: (left: 3cm, right: 2cm, top: 2cm, bottom: 2cm),
  background: context {
    if counter(page).get().first() == 1 {
      pad(
        left: 2.5cm, 
        right: 1.5cm, 
        top: 1.5cm, 
        bottom: 1.5cm,
        rect(
          width: 100%,
          height: 100%,
          stroke: 3pt,
          inset: 4pt,
          rect(
            width: 100%,
            height: 100%,
            stroke: 0.5pt
          )
        )
      )
    }
  }
)
#align(center, [
  #text(12pt)[*ĐẠI HỌC QUỐC GIA HÀ NỘI*] \  
  #text(12pt)[*TRƯỜNG ĐẠI HỌC CÔNG NGHỆ*] \
]) 
#v(25pt)
#align(center)[
  #image("images/Logo_HUET.svg", width: 6cm)
]
#v(25pt)
#align(center,[
  #text(20pt)[*BÁO CÁO DỰ ÁN*] \
  #v(8pt)
  #text(16pt)[*Ngành: Công nghệ thông tin*] \
  #v(16pt)
  
  #block(width: 90%)[
    #text(size: 18pt)[*PHÁT TRIỂN ỨNG DỤNG ĐỌC TRUYỆN TRANH HỖ TRỢ ĐA NGÔN NGỮ  BẰNG VIỆC ỨNG DỤNG AI TỰ ĐỘNG DỊCH*]
  ]
])
#v(18pt)
#align(center)[
  #text(size: 14pt)[*Giảng viên hướng dẫn: TS. Lê Hồng Hải*]

  #v(10pt)

  #text(size: 14pt)[*Sinh viên thực hiện: Nhóm 7*]
  #v(2pt)

  #text(size: 14pt)[*Nguyễn Đình Nguyên - 22021141*] \
  #v(4pt)
  #text(size: 14pt)[*Hoàng Lê Kim Long - 22021216*] \
  
  #text(size: 14pt)[*Hoàng Công Hữu - 22021178*]
  #v(5pt)

  #text(size: 14pt)[*Lớp: K67-IT1*]
]
#v(1fr)
#align(center, {
  text(size: 12pt)[*HÀ NỘI - 2026*]
})
