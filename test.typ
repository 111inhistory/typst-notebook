#import "@local/notebook:0.1.0": *

#show: conf

#show figure.where(kind: "example"): it => {
  it.fields()
}

#let testa(..args) = {
  let con = []
  for el in args.pos() {
    con += el
  }
  figure(kind: "example", ..args.named(), supplement: "example", con)
}

#testa(kind: "example", caption: "111")[222][2222222]<1111>

@1111

#show: frame-stylize.with(tag: "demo", main_color: color_map.at(2))
#let b = frame.with(kind: "demo", style: "simple")

#b[111]
