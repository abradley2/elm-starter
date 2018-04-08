module Component.TextArea exposing (textArea)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)


textArea params =
    div
        [ class ("input-field " ++ (Maybe.withDefault "" params.class))
        , id (params.id)
        , attribute "data-js-component" "textField"
        ]
        [ textarea
            [ id ("textarea-" ++ params.id)
            , class "materialize-textarea"
            , value params.value
            , onInput params.onInput
            , style [ ( "min-height", "80px" ) ]
            ]
            []
        , label
            [ for ("textarea-" ++ params.id)
            ]
            [ text params.label ]
        ]
