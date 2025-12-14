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

// Deprecated, will removed when I finish the migration
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

#let frame-boxy(
  main_color: none,
  bg_color: none,
  title-text-args: (),
  tag: none,
  cnt: none,
  ..args,
) = {
  if args.named().len() != 0 {
    panic("Unexpected named arguments", args.named())
  }
  let con = args.pos()
  let title = []
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

  let title_content = [#tag]
  if cnt != none {
    title_content = [#tag #context counter(heading).get().at(0)-#context cnt.get().at(0)]
  }

  let grid_cells = (
    rect(
      fill: main_color,
      inset: 0.5em,
      radius: if con.len() > 0 { (top-left: 0.5em) } else { (top: 0.5em) },
      stroke: (paint: main_color),
    )[
      #set text(..title-text-args);#title_content #title
    ],
  )
  for (idx, i) in con.enumerate() {
    grid_cells.push(rect(
      fill: bg_color,
      inset: 0.5em,
      radius: if (idx != con.len() - 1) { (top: 0em) } else {
        (top-right: 0.5em)
      },
      stroke: (paint: main_color),
    )[#align(
      horizon,
      i,
    )])
  }

  if cnt != none {
    let columns = ()
    for i in range(grid_cells.len()) { columns.push(auto) }
    columns.push(1fr)

    let header = grid(columns: columns, rows: (
        1.8em,
      ), ..grid_cells, [])
    let main = block(
      width: 100%,
      above: -1pt,
      inset: 1em,
      stroke: (paint: main_color),
      radius: (bottom: 1em),
      fill: bg_color,
    )[#set text(..body-text-args);#body]
    [#cnt.step()#align(left, header)#main]
  } else {
    let columns = ()
    for i in range(grid_cells.len()) {
      columns.push(auto)
    }
    let main = block(
      width: 100%,
      above: -1pt,
      inset: 1em,
      stroke: (paint: main_color),
      radius: (top-right: 1em, bottom: 1em),
      fill: bg_color,
    )[#body]
    grid(columns: columns, rows: 2, ..grid_cells, grid.cell(
        colspan: grid_cells.len(),
      )[#main])
  }
}

#let frame-simple(
  main_color: none,
  bg_color: none,
  title-text-args: none,
  tag: none,
  cnt: none,
  ..args,
) = {
  if args.named().len() != 0 {
    panic("Unexpected named arguments", args.named())
  }
  let con = args.pos()
  let title = []
  if con.len() > 1 {
    title = con.at(0)
    let _ = con.remove(0)
  }
  let title-text-default = (weight: "bold", fill: main_color.darken(50%))
  let title-args = merge_dict(title-text-default, title-text-args)

  let title_content = [#tag]
  if cnt != none {
    title_content = [#tag #context counter(heading).get().at(0)-#context cnt.get().at(0)]
  }

  let header = [#set text(..title-args);#set par(first-line-indent: 0em);#title_content #title]
  if cnt != none {
    header = [#context cnt.step() #header]
  }
  header += parbreak()
  let notes = []
  if con.len() > 1 {
    for i in range(con.len() - 2) {
      notes += con.at(i)
      notes += h(0.5em)
      notes += [|]
      notes += h(0.5em)
    }
    notes += con.at(-2)
    notes += parbreak()
  }
  let body = con.at(-1)
  block(
    width: 100%,
    inset: 1.2em,
    stroke: (left: (paint: main_color, thickness: 0.3em)),
    radius: 0.5em,
    fill: bg_color,
  )[
    #header
    #notes
    #body
  ]
}

#let frame-style = (boxy: frame-boxy, simple: frame-simple)

#let frame-factory(
  main_color: none,
  tag: none,
  show_counter: false,
  bg_color: none,
  transparency: 80%,
  title-text-args: none,
  style: "simple",
) = {
  let c = main_color
  let bg = if bg_color == none {
    main_color.opacify(-transparency)
  } else {
    bg_color
  }
  if type(tag) == str and show_counter {
    let cnt = counter("_frame_" + tag + "_counter")
    (..args) => context {
      frame-style.at(style)(
        main_color: c,
        bg_color: bg,
        title-text-args: title-text-args,
        tag: tag,
        cnt: cnt,
        ..args,
      )
    }
  } else {
    (..args) => context {
      frame-style.at(style)(
        main_color: c,
        bg_color: bg,
        title-text-args: title-text-args,
        tag: tag,
        ..args,
      )
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
