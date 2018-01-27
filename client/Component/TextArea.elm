module Component.TextArea exposing (textArea)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)


textArea params =
    div
        [ class ("input-field data-elm-lifecycle " ++ (Maybe.withDefault "" params.class))
        , id ("textfield-" ++ params.id)
        , attribute "data-js-component" "textField"
        ]
        [ textarea
            [ id params.id
            , class "materialize-textarea"
            , value params.value
            , onInput params.onInput
            ]
            []
        , label
            [ for params.id
            ]
            [ text params.label ]
        ]
