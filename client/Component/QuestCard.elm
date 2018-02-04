module Component.QuestCard exposing (questCard)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Types exposing (RecentPostedQuest)


questCard : RecentPostedQuest -> Html a
questCard params =
    div
        []
        [ text "I am a quest cards" ]
