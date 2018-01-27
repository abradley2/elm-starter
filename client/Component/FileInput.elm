module Component.FileInput exposing (fileInput)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Json.Decode


fileInput params =
    div [ class "input-field" ]
        [ input
            [ type_ "file"
            , id ("fileinput-" ++ params.id)
            , on "change" (Json.Decode.map params.onChange (Json.Decode.at [ "target", "files", "0", "name" ] Json.Decode.string))
            ]
            []
        , div
            [ class "file-path validate"
            , type_ "text"
            , value params.value
            ]
            []
        ]
