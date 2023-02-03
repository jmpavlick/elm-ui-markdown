module Markdown.Renderer.ElmUi exposing (renderer)

import Element exposing (Element)
import Markdown.Html as MHtml
import Markdown.Renderer exposing (Renderer)
import Markdown.Renderer.ElmUi.Internal as Internal


renderer : Renderer (Element msg)
renderer =
    { heading = Internal.heading
    , paragraph = Internal.paragraph
    , thematicBreak = Internal.thematicBreak
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
