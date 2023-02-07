module Markdown.Renderer.ElmUi exposing
    ( renderer
    , Error(..)
    , default
    , defaultWrapped
    )

{-| Markdown renderer that outputs [mdgriffith/elm-ui](https://package.elm-lang.org/packages/mdgriffith/elm-ui/latest/) Elements for [dillonkearns/elm-markdown](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/)


# Renderer

@docs renderer


# Convenience Functions

@docs Error

@docs default

@docs defaultWrapped

-}

import Element exposing (Element)
import Markdown.Html as MHtml
import Markdown.Parser as MParser
import Markdown.Renderer as Renderer exposing (Renderer)
import Markdown.Renderer.ElmUi.Internal as Internal
import Parser
import Parser.Advanced


{-| Default renderer. Since this value is a record, you can easily replace any of the field
values with a function that has the correct signature.

For instance: the default `thematicBreak` is a horizontal rule. If you wanted to replace this
with a series of emoji, you could do this:

    customRenderer : Renderer (Element msg)
    customRenderer =
        { renderer
            | thematicBreak =
                Element.el [ Element.centerX ] <|
                    Element.text "🖤🖤🖤"
        }

To use this with [dillonkearns/elm-markdown](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/),
you would just pass it as an argument to [Markdown.Renderer.render](https://package.elm-lang.org/packages/dillonkearns/elm-markdown/latest/Markdown-Renderer#render).

-}
renderer : Renderer (Element msg)
renderer =
    { heading = Internal.heading
    , paragraph = Internal.paragraph
    , thematicBreak = Internal.thematicBreak 2
    , text = Internal.text
    , strong = Internal.strong
    , emphasis = Internal.emphasis
    , strikethrough = Internal.strikethrough
    , codeSpan = Internal.codeSpan
    , link = Internal.link
    , hardLineBreak = Internal.hardLineBreak
    , image = Internal.image
    , blockQuote = Internal.blockQuote
    , unorderedList = Internal.unorderedList
    , orderedList = Internal.orderedList
    , codeBlock = Internal.codeBlock
    , html = MHtml.oneOf []
    , table = Internal.table
    , tableHeader = Internal.tableHeader
    , tableBody = Internal.tableBody
    , tableRow = Internal.tableRow
    , tableCell = Internal.tableCell
    , tableHeaderCell = Internal.tableHeaderCell
    }


{-| Wrapper for the two types of error that can be output by `Markdown.Parser.parse` and `Markdown.renderer.render`

This type is returned by `default` and `defaultWrapped` in the `Err` case.

-}
type Error
    = ParseError (List (Parser.Advanced.DeadEnd String Parser.Problem))
    | RenderError String


{-| Fast-path to render Markdown; returns the output from `Markdown.Renderer.render` as a `List (Element msg)`.

    markdown : String
    markdown =
        "# This is a H1"

    view : String -> Element msg
    view md =
        default md
            |> Result.map
                (Element.column
                    [ Element.width Element.fill
                    , Element.spacingXY 16 24
                    ]
                )
            |> Result.mapError
                (\_ -> Element.text "Something went wrong!")

-}
default : String -> Result Error (List (Element msg))
default markdownInput =
    MParser.parse markdownInput
        |> Result.mapError ParseError
        |> Result.andThen
            (\blocks ->
                Renderer.render renderer blocks
                    |> Result.mapError RenderError
            )


{-| Even faster path to render Markdown; wraps the output from `default` in

    Element.column
        [ Element.width Element.fill
        , Element.spacingXY 16 24
        ]

Here's how you could use it:

    markdown : String
    markdown =
        "## This is a H2"

    view : String -> Element msg
    view md =
        defaultWrapped md
            |> Result.map identity
            |> Result.mapError
                (\_ -> Element.text "Something went wrong!")

-}
defaultWrapped : String -> Result Error (Element msg)
defaultWrapped markdownInput =
    default markdownInput
        |> Result.map
            (\elements ->
                Element.column [ Element.width Element.fill, Element.spacingXY 16 24 ] elements
            )
