module View.QuestDetailsView.SideQuestDetails exposing (sideQuestDetails)

import Html
import Array
import Theme
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.QuestDetailsMessage exposing (QuestDetailsMessage, QuestDetailsMessage(..))
import Types exposing (SideQuest)
import Component.Modal exposing (modal)


sideQuestDetails : SideQuest -> Html QuestDetailsMessage
sideQuestDetails sideQuest =
    div [] []
