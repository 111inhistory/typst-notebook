#import "utils.typ": merge_dict

#let conceal(prompt, it) = {
  [
    #sym.triangle.filled.r
    #text(prompt)
  ]
}

#let vt(it) = {
  math.accent(it, math.harpoon)
}

#let Arg = math.op("Arg")

#let todo(it) = {
  box(
    fill: rgb("#ffeb3b"),
    outset: 2pt,
    radius: 2pt,
  )[
    #text(weight: "bold", fill: rgb("#f57c00"))[TODO: ]#it
  ]
}

#let ddot = math.dot.double
// #let ddot(m) = math.accent(m, math.dot.double)

#let vb(it) = {
  math.bold(math.upright(it))
}

#let make_heading(body, font-size, show-line: true) = {
  set par(first-line-indent: 0em)
  set text(size: font-size, cjk-latin-spacing: none)
  block(width: 100%, above: 1.5em, below: 1em, breakable: false, sticky: true)
  [
    #box(
      width: 100%,
      stroke: if show-line { (bottom: (paint: luma(70%), thickness: 1.5pt)) } else { none },
      outset: (bottom: 0.3em),
      body,
    )
  ]
}

#let customized_outline() = {
  set page(header: none)
  v(2em)
  make_heading(strong("Content"), 22pt, show-line: true)
  v(2em)
  outline(title: none)
}

#let prelude(
  title: none,
  subtitle: none,
  abstract: none,
  title_text_conf: none,
  subtitle_text_conf: none,
  abstract_title_conf: none,
) = {
  set page(header: none)
  set par(first-line-indent: 0em)
  align(horizon + left)[
    #if title != none and title != "" {
      text(size: 20pt)[#h(20pt)*#title*]
    }
    #if abstract != none and abstract != "" {
      v(2em)
      align(center)[#block(
        stroke: (thickness: 0.5pt),
        inset: 0.5em,
        outset: 1em,
        width: 90%,
      )[#align(left)[#h(2em)#abstract]]]
    }
  ]

  pagebreak()
}

#state("bib", ())

#let load-bib(..args) = context {
  import "@preview/citegeist:0.2.0": load-bibliography
  let a = read(..args)
  let b = state("bib").get()
  b.push(dic => dic.push(load-bibliography(a)))
}

#let code(..args, body) = {
  import "utils.typ": merge_dict
  import "@preview/zebraw:0.6.1": *
  import "config.typ": custom_zebraw_style
  let a = merge_dict(custom_zebraw_style, args.named())
  zebraw(body, ..args.pos(), ..a)
}

#let h2 = h(-2em)

#let cases(..args) = math.cases(..args.named(), ..args.pos().map(math.display))

#let mat(..args) = {
  let pos = args.pos()
  if type(pos.at(0)) == array {
    math.mat(..args.named(), ..pos.map(it => it.map(math.display)))
  } else {
    math.mat(..args.named(), ..pos.map(math.display))
  }
}

#let because = {
  set text(size: 1.35em)
  math.because
}

#let therefore = {
  set text(size: 1.35em)
  math.therefore
}

#let neq = math.eq.not

#let parb = parbreak()
#let pageb = pagebreak()