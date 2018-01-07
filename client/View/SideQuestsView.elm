module View.SideQuestsView exposing (sideQuestsView)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.SideQuestsMessage exposing (SideQuestsMessage, SideQuestsMessage(..))


sideQuestsView : Model -> Html SideQuestsMessage
sideQuestsView model =
    div [ class "center measure" ]
        [ a [ href "#" ] [ text "Armies" ]
        , h3 [] [ text "About Page" ]
        ]
