module Component.FlatButton exposing (..)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)


type alias Params a =
    { label : String
    , onClick : a
    }


flatButton : Params a -> Html a
flatButton params =
    span
        [ class "waves-effect waves-teal btn-flat"
        , onClick params.onClick
        ]
        [ text params.label ]
