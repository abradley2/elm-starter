module View.UnitsView exposing (unitsView)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.UnitsMessage exposing (UnitsMessage)


unitsView : Model -> Html UnitsMessage
unitsView model =
    div [ class "center measure" ]
        [ a [ href "#" ] [ text "Home" ]
        , h3 [] [ text "About Page" ]
        ]
