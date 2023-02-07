module Markdown.Renderer.ElmUi exposing (Error(..), default, renderer)

import Element exposing (Element)
import Markdown.Html as MHtml
import Markdown.Parser as MParser
import Markdown.Renderer as Renderer exposing (Renderer)
import Markdown.Renderer.ElmUi.Internal as Internal
import Parser
import Parser.Advanced


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


type Error
    = ParseError (List (Parser.Advanced.DeadEnd String Parser.Problem))
    | RenderError String


default : String -> Result Error (List (Element msg))
default markdownInput =
    MParser.parse markdownInput
        |> Result.mapError ParseError
        |> Result.andThen
            (\blocks ->
                Renderer.render renderer blocks
                    |> Result.mapError RenderError
            )
