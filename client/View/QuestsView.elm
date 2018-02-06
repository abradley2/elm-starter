module View.QuestsView exposing (questsView)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.QuestsMessage exposing (QuestsMessage, QuestsMessage(..))
import Component.TextField exposing (textField)
import Component.QuestCard exposing (questCard)


questsView : Model -> Html QuestsMessage
questsView model =
    div
        [ css
            [ padding4 (px 16) (px 8) (px 0) (px 8) ]
        ]
        [ div
            [ css
                [ displayFlex
                , flexWrap Css.wrap
                , alignItems Css.center
                ]
            ]
            (List.map
                (\quest -> questCard quest { showUserImage = True })
                model.quests.questList
            )
        ]
