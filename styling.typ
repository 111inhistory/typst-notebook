#import "addition.typ": *
#import "utils.typ": *
#import "config.typ": *
#import "@preview/in-dexter:0.7.2"
#import "@preview/zebraw:0.5.5": *
#import "@preview/citegeist:0.2.0": load-bibliography

#let heading-size = state("heading-size", (20pt, 8pt))
#let par-spacing-state = state("par-spacing", 1.2em)
#let page-conf-state = state("page-conf", (:))
#let par-conf-state = state("par-conf", (:))
#let text-conf-state = state("text-conf", (:))
#let heading-conf-state = state("heading-conf", (:))
#let list-conf-state = state("list-conf", (:))
#let enum-conf-state = state("enum-conf", (:))
#let terms-conf-state = state("terms-conf", (:))
#let figure-conf-state = state("figure-conf", (:))
#let underline-conf-state = state("underline-conf", (:))
#let code-text-conf-state = state("code-text-conf", (:))

#let custom-list-enum(doc) = {
  show list: li => context {
    let outer-spacing = par-spacing-state.final()
    set par(
      spacing: if li.tight { 0.65em } else { outer-spacing },
      leading: if li.tight { 0.65em } else { 0.8em },
    )
    for (i, it) in li.children.enumerate() {
      let parents = state("enum-list-parents", ())
      let marker = context {
        let n = parents.get().len()
        if type(li.marker) == array {
          li.marker.at(calc.rem-euclid(n, li.marker.len()))
        } else if type(li.marker) == content {
          li.marker
        } else {
          li.marker(n)
        }
      }
      let body = {
        parents.update(arr => arr + (1,))
        it.body + parbreak()
        parents.update(arr => arr.slice(0, -1))
      }
      let content = {
        set par(hanging-indent: 2em)
        context h(-measure(marker).width - li.body-indent)
        marker
        h(li.body-indent)
        body
      }
      // content
      [#context if parents.get().len() == 0 {
        content
      } else {
        pad(left: li.indent, content)
      }]
    }
  }

  show enum: en => context {
    let outer-spacing = par-spacing-state.get()
    set par(
      spacing: if en.tight { 0.65em } else { outer-spacing },
      leading: if en.tight { 0.65em } else { 0.8em },
    )
    let start = none
    if en.start != auto {
      start = en.start
    } else if (
      en.children.first().has("number") and en.children.first().number != auto
    ) {
      start = en.children.first().number
    } else if en.reversed {
      start = items.len()
    } else {
      start = 1
    }

    let delta = if en.reversed { -1 } else { 1 }

    let number = start
    for (i, it) in en.children.enumerate() {
      number = if it.has("number") and it.number != auto { it.number } else {
        number
      }
      let parents = state("enum-list-parents", ())
      let indent = context h(parents.get().len() * en.indent)
      let num = if en.full {
        context text(font: code-font, numbering(en.numbering, ..parents.get(), number))
      } else {
        numbering(en.numbering, number)
      }
      let max-num = if en.full {
        context text(font: code-font, numbering(en.numbering, ..parents.get(), en.children.len()))
      } else {
        numbering(en.numbering, en.children.len())
      }
      num = context box(
        width: measure(max-num).width,
        [#align(right, text(overhang: false, num))],
      )
      let body = {
        parents.update(arr => arr + (number,))
        it.body + parbreak()
        parents.update(arr => arr.slice(0, -1))
      }
      number += delta
      let content = {
        set par(hanging-indent: 2em)
        context h(-measure(num).width - en.body-indent)
        num
        h(en.body-indent)
        body
      }
      if parents.get().len() == 0 {
        content
      } else {
        pad(left: en.indent, content)
      }
    }
  }
  doc
}

#let notebook_heading(heading_size, it) = context {
  let size = level_to_size(it.level, ..heading-size.get())
  let body = [
    #if it.numbering != none {
      numbering(it.numbering, ..counter(heading).get())
      h(0.5em)
    }#it.body
  ]
  make_heading(body, size, show-line: it.depth <= 2)
}

#let notebook_link(it) = {
  box()[
    #set text(blue)
    #underline(it, stroke: (thickness: 0.5pt, paint: blue))
  ]
}

#let notebook_ref(it) = context {
  let a = state("bib").final()
  if it.element == none and (a == none or not a.keys().contains(str(it.target))) {
    text(fill: orange.darken(10%), weight: "bold", "[? " + str(it.target) + "]")
  } else {
    set text(blue)
    underline(it, stroke: (thickness: 0.5pt, paint: blue))
  }
}

#let notebook_inline_code(it) = {
  set text(top-edge: "ascender", bottom-edge: "descender", weight: "regular", fill: rgb("#d73a49"), size: 1em)
  [
    #box(
      fill: luma(96%),
      radius: 3pt,
      inset: (x: 3pt, y: 0pt),
      outset: (y: 2pt),
      baseline: 10%,
    )[#it]
  ]
}

#let do-nothing(..args, it) = { it }

#let conf(
  custom-heading: notebook_heading, // function
  custom-list-enum: custom-list-enum, // function
  custom-link: notebook_link,
  custom-ref: notebook_ref,
  custom-inline-code: notebook_inline_code,
  cjk-italic-font: ("LXGW WenKai GB",),
  inline-math-display: math.display, // math.display | math.inline
  heading_size: (10pt, 22pt),
  inline-math-spacing: 0.15em,
  ..args,
  doc,
) = {
  let a = args.named()
  let b = args.pos()
  for i in b {
    if type(i) == dictionary {
      a.insert(i.keys().at(0), i.at(i.keys().at(0)))
    } else {
      panic("Unexpected argument in conf: ", i)
    }
  }
  let page-conf = if a.keys().contains("page") { a.at("page") } else {
    default_page_config
  }
  let par-conf = if a.keys().contains("par") { a.at("par") } else {
    default_par_config
  }
  let text-conf = if a.keys().contains("text") { a.at("text") } else {
    default_text_config
  }
  let heading-conf = if a.keys().contains("heading") {
    a.at("heading")
  } else {
    default_heading_config
  }
  let list-conf = if a.keys().contains("list") {
    a.at("list")
  } else {
    default_list_config
  }
  let enum-conf = if a.keys().contains("enum") {
    a.at("enum")
  } else {
    defualt_enum_config
  }
  let terms-conf = if a.keys().contains("terms") {
    a.at("term")
  } else {
    default_terms_config
  }
  let figure-conf = if a.keys().contains("figure") {
    a.at("figure")
  } else {
    default_figure_config
  }
  let underline-conf = if a.keys().contains("underline") {
    a.at("underline")
  } else {
    default_underline_config
  }
  let code-text-conf = if a.keys().contains("code-text") {
    a.at("code-text")
  } else {
    default_code_text_config
  }

  let _ = context {
    par-spacing-state.update(par-conf.at("spacing", default: 1.2em))
    page-conf-state.update(page-conf)
    par-conf-state.update(par-conf)
    text-conf-state.update(text-conf)
    heading-conf-state.update(heading-conf)
    list-conf-state.update(list-conf)
    enum-conf-state.update(enum-conf)
    terms-conf-state.update(terms-conf)
    figure-conf-state.update(figure-conf)
    underline-conf-state.update(underline-conf)
    code-text-conf-state.update(code-text-conf)
  }

  // show: _config_page.with(page-conf)
  // show: _config_par.with(par-conf)
  // show: _config_text.with(text-conf)
  // show: _config_heading.with(heading-conf)
  // show: _config_list.with(list-conf)
  // show: _config_enum.with(enum-conf)
  // show: _config_terms.with(terms-conf)
  // show: _config_figure.with(figure-conf)
  // show: _config_underline.with(underline-conf)

  set page(..page-conf)
  set par(..par-conf)
  set text(..text-conf)
  set heading(..heading-conf)
  set list(..list-conf)
  set enum(..enum-conf)
  set terms(..terms-conf)
  set figure(..figure-conf)
  set underline(..underline-conf)

  show raw: set text(..code-text-conf)

  show: custom-list-enum
  show heading: custom-heading.with(heading_size)
  show link: custom-link
  show ref: custom-ref
  show raw.where(block: false): custom-inline-code

  show emph: it => {
    show regex("[\\u4e00-\\u9fa5\\uFF00-\\uFFEF]+"): it => {
      text(font: cjk-italic-font)[#it]
    }
    it
  }

  show figure.where(kind: "image"): set figure(supplement: "图")
  show figure.where(kind: "table"): set figure(supplement: "表")
  show figure: it => {
    block()[#it]
  }

  show math.equation.where(block: false): inline-math-display
  show math.equation.where(block: true): set text(size: 13pt)

  show math.equation.where(block: false): it => [#h(inline-math-spacing)#it#h(inline-math-spacing)]

  show: zebraw.with(..custom_zebraw_style)

  doc
}
