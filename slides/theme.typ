#let accent = rgb("#C0392B")
#let light-bg = rgb("#F7F1F1")
#let slide-title(body) = {
  text(size: 22pt, weight: "bold", fill: accent)[#body]
  v(0.1em)
  line(length: 100%, stroke: 0.6pt + accent)
  v(0.5em)
}
#let tag(body) = text(size: 13pt, fill: gray.darken(30%))[#body]
#let note(body) = block(
  fill: light-bg, inset: 0.7em, radius: 4pt, width: 100%,
)[#text(size: 18pt)[#body]]
