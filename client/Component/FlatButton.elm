module Component.FlatButton exposing (flatButton)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)


flatButton params =
    span
        [ class "waves-effect waves-teal btn-flat"
        , onClick params.onClick
        ]
        [ text params.label ]
