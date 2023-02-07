# elm-ui-markdown

This package provides a Markdown renderer that outputs [mdgriffith/elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) Elements for [dillonkearns/elm-markdown](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/).

The renderer is a record of type alias [Markdown.Renderer.Renderer](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/Markdown-Renderer#Renderer), with the `view` type parameter made concrete as an instance of [Element msg](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/Element#Element).

You can see a live preview of the renderers at https://elm-ui-markdown.vercel.app/, which is the hosted version of [the `example` directory in this repository](https://github.com/jmpavlick/elm-ui-markdown/tree/master/example).