module Component.RaisedButton exposing (raisedButton)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)


raisedButton params =
    span
        [ class "btn"
        , onClick params.onClick
        ]
        [ case params.icon of
            Just icon ->
                i [ class "material-icons left" ] [ text icon ]

            Nothing ->
                span [] []
        , text params.label
        ]
