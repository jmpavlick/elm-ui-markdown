port module Main exposing (..)

import Browser
import Element exposing (Attribute, Element)
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Html exposing (Html)
import Http
import Json.Encode as Encode
import Markdown.Renderer.ElmUi as Renderer


port store : Encode.Value -> Cmd msg


type alias Model =
    { markdownText : Maybe String
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
    let
        defaultedMarkdownText : String
        defaultedMarkdownText =
            Maybe.withDefault "" markdownText
    in
    Element.layout [] <|
        Element.column [ Element.width Element.fill ]
            [ Element.el [ Element.width <| Element.fill, Element.alignTop ] <| controls
            , Element.row [ Element.padding 10, Element.spacing 10, Element.width Element.fill ]
                [ Element.el [ Element.width <| Element.fillPortion 1, Element.alignTop ] <| input defaultedMarkdownText
                , Element.el [ Element.width <| Element.fillPortion 1, Element.alignTop ] <| preview defaultedMarkdownText
                ]
            ]


type alias Flags =
    { userMarkdownText : String
    }


init : Flags -> ( Model, Cmd Msg )
init { userMarkdownText } =
    ( { markdownText =
            if String.isEmpty userMarkdownText then
                Nothing

            else
                Just userMarkdownText
      , sampleText = ""
      }
    , Http.get { url = "./sample-text.md", expect = Http.expectString GotSampleText }
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ClickedReset ->
            ( { model | markdownText = Just model.sampleText }
            , Encode.string "" |> store
            )

        ClickedClear ->
            ( { model | markdownText = Nothing }
            , Cmd.none
            )

        UpdatedMarkdownText markdownText ->
            ( { model | markdownText = Just markdownText }
            , Encode.string markdownText |> store
            )

        GotSampleText (Ok sampleText) ->
            ( { model
                | sampleText = sampleText
                , markdownText =
                    case model.markdownText of
                        Nothing ->
                            Just sampleText

                        Just userMarkdownText ->
                            Just userMarkdownText
              }
            , Cmd.none
            )

        GotSampleText (Err _) ->
            ( model, Cmd.none )


main : Program Flags Model Msg
main =
    Browser.document
        { init = init
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
