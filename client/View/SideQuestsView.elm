module View.UnitsView exposing (unitsView)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.SideQuestsMessage exposing (SideQuestsMessage)


unitsView : Model -> Html SideQuestsMessage
unitsView model =
    div [ class "center measure" ]
        [ a [ href "#" ] [ text "Armies" ]
        , h3 [] [ text "About Page" ]
        ]
