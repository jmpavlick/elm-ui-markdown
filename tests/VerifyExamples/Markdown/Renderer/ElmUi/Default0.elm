module VerifyExamples.Markdown.Renderer.ElmUi.Default0 exposing (..)

-- This file got generated by [elm-verify-examples](https://github.com/stoeffel/elm-verify-examples).
-- Please don't modify this file by hand!

import Test
import Expect

import Markdown.Renderer.ElmUi exposing (..)



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
markdown : String
markdown =
    "# This is a H1"



spec0 : Test.Test
spec0 =
    Test.test "#default: \n\n    view markdown\n    --> Element.column [] []" <|
        \() ->
            Expect.equal
                (
                view markdown
                )
                (
                Element.column [] []
                )