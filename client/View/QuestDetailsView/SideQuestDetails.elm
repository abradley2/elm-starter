module View.QuestDetailsView.SideQuestDetails exposing (sideQuestDetails)

import Html
import Array
import Theme
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Update.QuestDetailsUpdate exposing (QuestDetailsMsg, QuestDetailsMsg(..))
import Types exposing (SideQuest)
import Component.Modal exposing (modal)
import Component.FlatButton exposing (flatButton)
import Component.RaisedButton exposing (raisedButton)


sideQuestDetails : SideQuest -> Html QuestDetailsMsg
sideQuestDetails sideQuest =
    modal
        { noop = NoOp
        , content =
            div []
                [ p [ class "flow-text" ] [ text "Would you like to accept this side quest?" ]
                ]
        , footer =
            div []
                [ (flatButton
                    { onClick = DeclineSuggestedSideQuest
                    , label = "NAY"
                    }
                  )
                , (raisedButton
                    { onClick = AcceptSuggestedSideQuest
                    , label = "YAY"
                    , icon = Nothing
                    , disabled = False
                    }
                  )
                ]
        , id = "side-quest-details-modal"
        , open = True
        , onRequestClose = (ToggleShowingSideQuestModal Nothing)
        }
