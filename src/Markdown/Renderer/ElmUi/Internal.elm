module Markdown.Renderer.ElmUi.Internal exposing (..)

import Element exposing (Attribute, Element)
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html
import Html.Attributes as Attr
import Markdown.Block as Block


colors :
    { link : Element.Color
    , accent : Element.Color
    }
colors =
    { link = Element.rgb255 0x09 0x69 0xDA
    , accent = Element.rgba255 0xCC 0xCC 0xCC 0.7
    }


heading :
    { level : Block.HeadingLevel
    , rawText : String
    , children : List (Element msg)
    }
    -> Element msg
heading { level, children } =
    let
        ( size, decoration ) =
            case level of
                Block.H1 ->
                    ( 32, thematicBreak 1 )

                Block.H2 ->
                    ( 28, thematicBreak 1 )

                Block.H3 ->
                    ( 26, Element.none )

                Block.H4 ->
                    ( 24, Element.none )

                Block.H5 ->
                    ( 22, Element.none )

                Block.H6 ->
                    ( 20, Element.none )
    in
    Element.column [ Element.width Element.fill ]
        [ Element.paragraph
            [ Font.size size
            , Font.bold
            , Region.heading <| Block.headingLevelToInt level
            ]
            children
        , decoration
        ]


paragraph : List (Element msg) -> Element msg
paragraph =
    Element.paragraph []


thematicBreak : Int -> Element msg
thematicBreak thickness =
    Element.el
        [ Element.width <| Element.fill
        , Element.paddingXY 0 10
        ]
    <|
        Element.el
            [ Border.widthEach { top = thickness, bottom = 0, left = 0, right = 0 }
            , Border.color colors.accent
            , Element.height <| Element.px 0
            , Element.width <| Element.fill
            , Element.height <| Element.px 0
            ]
        <|
            Element.none


text : String -> Element msg
text =
    Element.text


strong : List (Element msg) -> Element msg
strong =
    Element.row [ Font.semiBold ]


emphasis : List (Element msg) -> Element msg
emphasis =
    Element.row [ Font.italic ]


strikethrough : List (Element msg) -> Element msg
strikethrough =
    Element.row [ Font.strike ]


codeSpan : String -> Element msg
codeSpan rawText =
    Element.el [ Font.family [ Font.monospace ] ] <| Element.text rawText


link :
    { title : Maybe String
    , destination : String
    }
    -> List (Element msg)
    -> Element msg
link { destination } body =
    Element.newTabLink
        [ Element.htmlAttribute <| Attr.style "display" "inline-flex"
        ]
        { url = destination, label = Element.paragraph [ Font.color <| colors.link ] body }


hardLineBreak : Element msg
hardLineBreak =
    Element.html <| Html.br [] []


image : { src : String, alt : String, title : Maybe String } -> Element msg
image { src, alt, title } =
    let
        base : Element msg
        base =
            Element.image
                [ Element.width Element.fill
                ]
                { src = src, description = alt }

        withTitle : String -> Element msg
        withTitle t =
            Element.column [ Element.spacingXY 0 8 ]
                [ base
                , Element.el [ Element.centerX ] <| Element.text t
                ]
    in
    Maybe.map withTitle title
        |> Maybe.withDefault base


blockQuote : List (Element msg) -> Element msg
blockQuote els =
    Element.el [ Element.paddingXY 0 4 ] <|
        Element.column
            [ Element.padding 10
            , Border.widthEach { top = 0, bottom = 0, right = 0, left = 10 }
            , Border.color <| colors.accent
            ]
            els


unorderedListItem : Block.ListItem (Element msg) -> Element msg
unorderedListItem (Block.ListItem task children) =
    let
        bullet : Element msg
        bullet =
            case task of
                Block.IncompleteTask ->
                    Input.defaultCheckbox False

                Block.CompletedTask ->
                    Input.defaultCheckbox True

                Block.NoTask ->
                    Element.text "•"
    in
    Element.row []
        [ Element.el
            [ Element.paddingEach
                { top = 4
                , bottom = 0
                , left = 2
                , right = 8
                }
            , Element.alignTop
            ]
            bullet
        , Element.column [ Element.width Element.fill ]
            [ Element.column
                [ Element.paddingXY 0 4
                ]
                children
            ]
        ]


unorderedList : List (Block.ListItem (Element msg)) -> Element msg
unorderedList items =
    List.map unorderedListItem items
        |> Element.column []


orderedList : Int -> List (List (Element msg)) -> Element msg
orderedList startingIndex items =
    Element.column [] <|
        List.indexedMap
            (\index itemBlocks ->
                Element.row [ Element.spacing 5 ]
                    [ Element.row [ Element.alignTop ] <|
                        Element.text
                            (String.fromInt (index + startingIndex) ++ ". ")
                            :: itemBlocks
                    ]
            )
            items


codeBlock : { body : String, language : Maybe String } -> Element msg
codeBlock { body } =
    Html.pre [] [ Html.text body ] |> Element.html


table : List (Element msg) -> Element msg
table =
    Element.column [ Element.width Element.fill ]


tableHeader : List (Element msg) -> Element msg
tableHeader children =
    Element.column [ Element.width Element.fill ]
        [ Element.row [ Font.bold, Element.width Element.fill ] <|
            List.map (\td -> Element.el [ Element.width <| Element.fillPortion <| List.length children ] td)
                children
        ]


tableBody : List (Element msg) -> Element msg
tableBody =
    Element.column [ Element.width Element.fill ]


tableRow : List (Element msg) -> Element msg
tableRow children =
    Element.column [ Element.width Element.fill ]
        [ Element.row [ Element.width Element.fill, Element.paddingXY 0 4 ] <|
            List.map (\td -> Element.el [ Element.width <| Element.fillPortion <| List.length children ] td)
                children
        ]


tableCell : Maybe Block.Alignment -> List (Element msg) -> Element msg
tableCell _ =
    Element.paragraph []


tableHeaderCell : Maybe Block.Alignment -> List (Element msg) -> Element msg
tableHeaderCell _ =
    Element.paragraph []
