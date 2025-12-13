
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
  set text(size: font-size, cjk-latin-spacing: none)
  block(breakable: false, sticky: true)
  [
    #body
    #if show-line {
      v(-0.8em)
      line(length: 100%, stroke: 1pt + luma(60%))
    }
    #v(0.5em)
  ]
}

#let customized_outline() = {
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

#let frame(
  title,
  body,
  title_prefix: [],
  main_color: white,
  transparency: 80%,
  bg_color: none,
) = {
  align(left)[
    #rect(
      fill: main_color,
      inset: 0.5em,
      radius: (top: 0.5em),
      stroke: (paint: main_color),
    )[#title_prefix#title]
  ]
  block(
    width: 100%,
    above: 0%,
    inset: 1em,
    stroke: (paint: main_color),
    radius: (top-right: 1em, bottom: 1em),
    fill: if bg_color == none { main_color.opacify(-transparency) } else {
      bg_color
    },
  )[
    #body
  ]
}

#let frame-factory(
  title_prefix: [],
  main_color: none,
  tag: none,
  show_counter: false,
  bg_color: none,
  transparency: 80%,
  title-text-args: (),
  body-text-args: (),
) = {
  let c = main_color
  let bg = if bg_color == none { main_color.opacify(-transparency) } else { bg_color }
  if type(tag) == str and show_counter {
    let cnt = counter("_frame_" + tag + "_counter")
    (..args) => {
      if args.named().len() != 0 { panic("Unexpected named arguments", args.named()) }
      let con = args.pos()
      let title = none
      let body = none
      if con.len() == 1 {
        body = con.at(0)
        let _ = con.remove(0)
      } else {
        title = con.at(0)
        body = con.at(-1)
        let _ = con.remove(0)
        let _ = con.remove(-1)
      }
      let grid_cells = (
        rect(
          fill: c,
          inset: 0.5em,
          radius: if con.len() > 0 { (top-left: 0.5em) } else { (top: 0.5em) },
          stroke: (paint: c),
        )[
          #set text(..title-text-args);#title_prefix#title
        ],
      )
      for i in con {
        grid_cells.push(rect(fill: bg, inset: 0.5em, radius: (top-right: 0.5em), stroke: (paint: c))[#align(
          horizon,
          i,
        )])
      }
      let tagging = rect(
        fill: c,
        inset: 0.5em,
        radius: (top: 0.5em),
        stroke: (paint: c),
      )[#tag #context counter(heading).get().at(0)-#context cnt.get().at(0)]

      let columns = ()
      for i in range(grid_cells.len()) { columns.push(auto) }
      columns.push(1fr)
      columns.push(auto)

      let header = grid(columns: columns, rows: (1.8em,), ..grid_cells, [], tagging)
      let main = block(
        width: 100%,
        above: -1pt,
        inset: 1em,
        stroke: (paint: main_color),
        radius: (bottom: 1em),
        fill: bg,
      )[#set text(..body-text-args);#body]
      [#cnt.step()#align(left, header)#main]
    }
  } else {
    (..args) => {
      if args.named().len() != 0 {
        panic("Unexpected named arguments", args.named())
      }
      let con = args.pos()
      let title = none
      let body = none
      if con.len() == 1 {
        body = con.at(0)
        let _ = con.remove(0)
      } else {
        title = con.at(0)
        body = con.at(-1)
        let _ = con.remove(0)
        let _ = con.remove(-1)
      }
      let grid_cells = (
        rect(
          fill: c,
          inset: 0.5em,
          radius: if con.len() > 0 { (top-left: 0.5em) } else { (top: 0.5em) },
          stroke: (paint: c),
        )[#set text(..title-text-args);#title_prefix#title],
      )
      for i in con {
        grid_cells.push(rect(fill: bg, inset: 0.5em, radius: (top-right: 0.5em), stroke: (paint: c))[#align(
          horizon,
          i,
        )])
      }
      let columns = ()
      for i in range(grid_cells.len()) {
        columns.push(auto)
      }
      let header = grid(columns: columns, ..grid_cells)
      let main = block(
        width: 100%,
        above: -1pt,
        inset: 1em,
        stroke: (paint: main_color),
        radius: (top-right: 1em, bottom: 1em),
        fill: bg,
      )[#set text(..body-text-args);#body]
      [#align(left, header)#main]
    }
  }
}

#let code(..args, body) = {
  import "utils.typ": merge_dict
  import "@preview/zebraw:0.6.1": *
  import "config.typ": custom_zebraw_style
  let a = merge_dict(custom_zebraw_style, args.named())
  zebraw(body, ..args.pos(), ..a)
}

#let h2 = h(2em)
