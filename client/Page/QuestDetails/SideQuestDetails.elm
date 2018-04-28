module Page.QuestDetails.SideQuestDetails exposing (sideQuestDetails)

import Page.QuestDetails.Update exposing (Msg, Msg(..))
import Array
import Theme
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Types exposing (SideQuest)
import Component.Modal exposing (modal)
import Component.FlatButton exposing (flatButton)
import Component.RaisedButton exposing (raisedButton)


sideQuestDetails : SideQuest -> Html Msg
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
