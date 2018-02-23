module Component.RaisedButton exposing (raisedButton)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)


type alias Params a =
    { disabled : Bool
    , icon : Maybe String
    , label : String
    , onClick : a
    }


raisedButton : Params a -> Html a
raisedButton params =
    span
        [ class
            ("btn "
                ++ if params.disabled then
                    "disabled"
                   else
                    ""
            )
        , onClick params.onClick
        ]
        [ case params.icon of
            Just icon ->
                i [ class "material-icons left" ] [ text icon ]

            Nothing ->
                span [] []
        , text params.label
        ]
