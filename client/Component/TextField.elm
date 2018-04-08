module Component.TextField exposing (textField)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)


textField params =
    div
        [ class ("input-field data-elm-lifecycle " ++ (Maybe.withDefault "" params.class))
        , id (params.id)
        , attribute "data-js-component" "textField"
        ]
        [ input
            [ id ("textfield-" ++ params.id)
            , value params.value
            , onInput params.onInput
            , type_ "text"
            ]
            []
        , label
            [ for ("textfield-" ++ params.id)
            ]
            [ text params.label ]
        ]
