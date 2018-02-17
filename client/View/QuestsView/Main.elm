module View.QuestsView.Main exposing (questsView)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.QuestsMessage exposing (QuestsMessage, QuestsMessage(..))
import Theme
import View.QuestsView.QuestAction exposing (questAction)
import Component.TextField exposing (textField)
import Component.QuestCard exposing (questCardWithActionSection)
import Component.RaisedButton exposing (raisedButton)


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
                (\quest ->
                    questCardWithActionSection quest
                        { showUserImage = True
                        , actionSection =
                            div []
                                [ (questAction
                                    { icon = "folder"
                                    , text = "Guidance"
                                    }
                                  )
                                , (questAction
                                    { icon = "cloud"
                                    , text = "Other"
                                    }
                                  )
                                ]
                        }
                )
                model.quests.questList
            )
        ]
