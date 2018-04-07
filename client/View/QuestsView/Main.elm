module View.QuestsView.Main exposing (questsView)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Update.QuestsUpdate exposing (QuestsModel, QuestsMsg, QuestsMsg(..))
import Theme
import Types exposing (Taco)
import View.QuestsView.QuestAction exposing (questAction)
import Component.TextField exposing (textField)
import Component.QuestCard exposing (questCardWithActionSection)
import Component.RaisedButton exposing (raisedButton)


questsView : Taco -> QuestsModel -> Html QuestsMsg
questsView taco model =
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
                (\quest ->
                    questCardWithActionSection quest
                        { showUserImage = True
                        , actionSection =
                            div []
                                [ (questAction
                                    { icon = "list"
                                    , text = "Details"
                                    , href = "#details/" ++ quest.userId ++ ":" ++ quest.id
                                    }
                                  )
                                ]
                        }
                )
                model.questList
            )
        ]
