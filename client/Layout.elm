module Layout exposing (layout)

import Css exposing (transform, translateX)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)


layout : Model -> Html a -> Html a
layout model view =
    div [ class "center measure" ]
        [ ul
            [ id "slide-out"
            , class "sidenav"
            , style [ ( "transform", "translateX(0%)" ) ]
            ]
            [ li []
                [ a [ href "#units" ] [ text "Units" ]
                ]
            , li []
                [ a [ href "#wargear" ] [ text "Wargear" ]
                ]
            ]
        , view
        ]
