# elm-ui-markdown

This package provides a Markdown renderer that outputs [mdgriffith/elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) Elements for [dillonkearns/elm-markdown](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/).

The renderer is a record of type alias [Markdown.Renderer.Renderer](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/Markdown-Renderer#Renderer), with the `view` type parameter made concrete as an instance of [Element msg](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element#Element).

This is a live preview! Below are samples for each field on the [Markdown.Renderer.Renderer](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/Markdown-Renderer#Renderer) type alias.

If you modify the contents of the live preview editor, your changes will be persisted to `localStorage` in your web browser.

----

Just above was a `thematicBreak`.

# This a H1
## This is a H2
### This is a H3
#### This is a H4
##### This is a H5
###### This is a H6

Here's a paragraph. A paragraph is a collection of `Element msg` values.

**This text is strong**. _This text is emphasized._ ~~This text is struck through.~~

`Here's a code span.`

[Here is a link! This is the default link formatting for text. If you click this link, you'll end up at my website.](https://pavlick.dev)

![Naughty Dogs](./noodle-and-baloney.webp "These are my dogs, Noodle and Baloney. They are here to show you how easy it is to add an image in a Markdown document. They have not ever done anything naughty.")

> If you want to add something in a blockquote,
> > or if you want a series of nested blockquotes,
> > > `elm-ui-markdown` has got your back.

----

|This|is|a|table|
|:---|--|:-:|----:|
|This column|This column|This column|This column|
|is left-aligned|has default alignment|is center-aligned|is right-aligned|

----

Here's a code block:

```
-- don't run this
void : a -> b
void a =
    void a
```