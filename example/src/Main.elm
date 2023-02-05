module Main exposing (..)

import Browser
import Element exposing (Attribute, Element)
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Http
import Markdown.Renderer.ElmUi as Renderer


type alias Model =
    { markdownText : String
    , sampleText : String
    }


type Msg
    = ClickedReset
    | ClickedClear
    | UpdatedMarkdownText String
    | GotSampleText (Result Http.Error String)


controls : Element Msg
controls =
    let
        button : Msg -> String -> Element Msg
        button onPress label =
            Input.button [ Border.width 2, Border.rounded 4, Element.padding 4 ] { onPress = Just onPress, label = Element.text label }
    in
    Element.row [ Element.spacing 10, Element.padding 4, Element.width Element.fill ]
        [ button ClickedClear "Clear"
        , button ClickedReset "Reset"
        ]


input : String -> Element Msg
input markdownText =
    Input.multiline
        [ Element.width Element.fill
        , Font.family [ Font.monospace ]
        ]
        { onChange = UpdatedMarkdownText
        , text = markdownText
        , placeholder = Nothing
        , label = Input.labelHidden "markdown editor input"
        , spellcheck = False
        }


view : Model -> Html Msg
view { markdownText } =
    Element.layout [] <|
        Element.column [ Element.width Element.fill ]
            [ Element.el [ Element.width <| Element.fill, Element.alignTop ] <| controls
            , Element.row [ Element.padding 10, Element.spacing 10, Element.width Element.fill ]
                [ Element.el [ Element.width <| Element.fillPortion 1, Element.alignTop ] <| input markdownText
                , Element.el [ Element.width <| Element.fillPortion 1, Element.alignTop ] <| preview markdownText
                ]
            ]


init : ( Model, Cmd Msg )
init =
    ( { markdownText = ""
      , sampleText = ""
      }
    , Http.get { url = "./sample-text.md", expect = Http.expectString GotSampleText }
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedReset ->
            ( { model | markdownText = model.sampleText }
            , Cmd.none
            )

        ClickedClear ->
            ( { model | markdownText = "" }
            , Cmd.none
            )

        UpdatedMarkdownText umdt ->
            ( { model | markdownText = umdt }
            , Cmd.none
            )

        GotSampleText (Ok sampleText) ->
            ( { model | markdownText = sampleText, sampleText = sampleText }
            , Cmd.none
            )

        GotSampleText (Err _) ->
            ( model, Cmd.none )


main : Program () Model Msg
main =
    Browser.document
        { init = \_ -> init
        , view = view >> List.singleton >> (\body -> { title = "elm-ui-markdown", body = body })
        , update = update
        , subscriptions = \_ -> Sub.none
        }


preview : String -> Element msg
preview markdownText =
    case Renderer.default markdownText of
        Ok [] ->
            Element.el [ Font.family [ Font.monospace ], Font.italic, Font.color <| Element.rgba255 0xCC 0xCC 0xCC 0.7 ] <| Element.text "Start typing."

        Ok elements ->
            Element.column [ Element.width Element.fill, Element.spacingXY 16 24 ] elements

        Err e ->
            Debug.toString e |> Element.text
