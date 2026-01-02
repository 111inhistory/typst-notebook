#import "./utils.typ": *
#import "@preview/numbly:0.1.0": numbly

#let main_color = rgb("#528ca8")

#let color-recipe = (
  main: rgb("#1D4E89"),
  light: rgb("#6BA3CC"),
  lighter: rgb("#E1EDF5"),
  lightest: rgb("#F0F6FA"),
  accent: rgb("#003153"),
  code-main: rgb("#b72433"),
  def: (bg: rgb("#ebf7d1").hsl().darken(10%).transparentize(65%), main: rgb("#78b10e")),
  theorem: (bg: rgb("#E0F2F1").hsl().darken(10%).transparentize(65%), main: rgb("#26A69A")),
  note: (bg: rgb("#FFF8E1").hsl().darken(10%).transparentize(65%), main: rgb("#FFB74D")),
  example: (bg: rgb("#F3E5F5").hsl().darken(10%).transparentize(65%), main: rgb("#9a1cb1")),
  proof: (bg: rgb("#ffeaef").hsl().darken(10%).transparentize(65%), main: rgb("#f791a9")),
)

#let default_page_config = (
  // 页面尺寸
  paper: "a4",
  // 控制是否横向
  flipped: false,
  // 左右，上下边界
  margin: (x: 1.5cm, y: 2.5cm),
  // 背景填充色，如果需要自定义背景需要将content传入background参数
  fill: tiling(size: (15pt, 15pt), rect(fill: rgb("#fdfbf7"), width: 100%, height: 100%, inset: 0pt)[
    #place(line(stroke: (paint: luma(90%), thickness: 0.3pt), start: (0%, 0%), end: (100%, 100%)))
    #place(line(stroke: (paint: luma(90%), thickness: 0.3pt), start: (0%, 100%), end: (100%, 0%)))
  ]),
  // 配置页码格式
  numbering: "1",
  header: context {
    let heading1 = query(heading.where(level: 1).after(here()))
    if heading1.len() == 0 or heading1.first().location().page() == here().page() { return [] }
    let heading2 = query(heading.where(level: 1).before(here()))
    [
      #set text(fill: color-recipe.main)
      #align(bottom)[
        #block(width: 100%, height: 1.5em)[
          #align(center)[
            #if (
              query(<frontmatter>).len() == 1 and query(<frontmatter>).at(0).value.keys().contains("title")
            ) {
              emph(query(<frontmatter>).at(0).value.at("title"))
            } else if document.title != none {
              emph(document.title)
            }#if heading2.len() > 0 {
              [-#emph(heading2.last().body)]
            }
          ]
          // 画一条线
          #place(bottom, dy: 0.5em)[#line(
            length: 100%,
            stroke: 1pt + color-recipe.light,
          )]
        ]
      ]
    ]
  },
)

#let default_cjk_font = ("Source Han Serif SC",)
// #let default_latin_font = ((name: "Arial", covers: regex("[\d•‣–]")),)
#let default_latin_font = ("Charter",)

#let default_text_config = (
  size: 12pt,
  fill: luma(15%),
  font: default_latin_font + default_cjk_font,
  cjk-latin-spacing: auto,
  weight: "medium",
  hyphenate: true,
)

#let default_par_config = (
  first-line-indent: (amount: 2em, all: true),
  spacing: 1.5em,
  justify: true,
  leading: 0.8em,
)

#let default_heading_config = (
  numbering: numbly(
    "{1:一}、",
    "{2}.",
    "{2}.{3}.",
    "{2}.{3}.{4}.",
  ),
  supplement: "章节",
)

#let default_list_config = (
  indent: 2em,
  body-indent: 0.5em,
)

#let default_enum_config = (
  indent: 2em,
  body-indent: 0.5em,
)

#let default_terms_config = (
  indent: 2em,
  separator: ": ",
)

#let default_figure_config = (
  numbering: (..nums) => {
    let figure_pos = nums.at(0)
    numbering("1-1", (counter(heading).at(here())).first(), figure_pos)
  },
  scope: "parent",
  placement: auto,
)

#let default_underline_config = (
  offset: 2pt,
  stroke: (
    paint: blue,
    thickness: 0.5pt,
  ),
)

#let default_code_text_config = (
  font: ("Maple Mono", "LXGW Wenkai GB"),
  size: 10pt,
)

#let custom_zebraw_style = (
  background-color: (luma(98%), luma(95%)),
  highlight-color: ratio_color(75%).lighten(70%),
  comment-color: ratio_color(55%).lighten(55%),
  lang-color: ratio_color(53%).lighten(10%),
  header: v(-1.5em),
  footer: v(-1.5em),
  numbering-separator: true,
  extend: false,
)

#let default_highlight_config = ()

#let config-page(..args) = {
  let b = args.named()
  return (page: merge_dict(default_page_config, b))
}


#let config-text(..args) = {
  let b = args.named()
  return (text: merge_dict(default_text_config, b))
}


#let config-par(..args) = {
  let b = args.named()
  return (par: merge_dict(default_par_config, b))
}


#let config-heading(..args) = {
  let b = args.named()
  return (heading: merge_dict(default_heading_config, b))
}


#let config-list(..args) = {
  let b = args.named()
  return (list: merge_dict(default_list_config, b))
}


#let config-enum(..args) = {
  let b = args.named()
  return (enum: merge_dict(default_enum_config, b))
}


#let config-terms(..args) = {
  let b = args.named()
  return (terms: merge_dict(default_terms_config, b))
}


#let config-figure(..args) = {
  let b = args.named()
  return (figure: merge_dict(default_figure_config, b))
}


#let config-underline(..args) = {
  let b = args.named()
  return (underline: merge_dict(default_underline_config, b))
}


#let config-code-text(..args) = {
  let b = args.named()
  return (code-text: merge_dict(default_code_text_config, b))
}

