module View.ArmiesView exposing (armiesView)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.ArmiesMessage exposing (ArmiesMessage, ArmiesMessage(..))


armiesView : Model -> Html ArmiesMessage
armiesView model =
    div [ class "center measure" ]
        [ h3 [] [ text "test" ]
        ]
