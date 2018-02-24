module View.QuestDetailsView.Main exposing (questDetailsView)

import Html
import Array
import Theme
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.QuestDetailsMessage exposing (QuestDetailsMessage, QuestDetailsMessage(..))


questDetailsView : Model -> Html QuestDetailsMessage
questDetailsView model =
    div [ class "container" ]
        [ h3 [] [ text "hi" ]
        ]
