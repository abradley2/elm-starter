module Component.TextField exposing (textField)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)


textField params =
    div
        [ class ("input-field " ++ (Maybe.withDefault "" params.class))
        , attribute "data-elm-lifecylce" params.id
        , attribute "data-js-component" "textField"
        ]
        [ input
            [ id params.id
            , value params.value
            , onInput params.onInput
            , type_ "text"
            ]
            []
        , label
            [ for params.id
            ]
            [ text params.label ]
        ]
