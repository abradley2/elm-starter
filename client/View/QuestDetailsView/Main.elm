module View.QuestDetailsView.Main exposing (questDetailsView)

import Array
import Theme
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Update.QuestDetailsUpdate exposing (QuestDetailsModel, QuestDetailsMsg, QuestDetailsMsg(..))
import Component.Stepper exposing (stepper)
import View.QuestDetailsView.SuggestedQuestsList exposing (suggestedQuestsList)
import View.QuestDetailsView.SideQuestDetails exposing (sideQuestDetails)
import View.QuestDetailsView.SideQuestForm exposing (sideQuestForm)
import Types exposing (RecentPostedQuest, SideQuest, Taco)


view : RecentPostedQuest -> List SideQuest -> List SideQuest -> QuestDetailsModel -> Html QuestDetailsMsg
view quest sideQuests suggestedSideQuests model =
    div [ class "container" ]
        [ div []
            [ h4 []
                [ text quest.name ]
            , div
                [ css
                    [ position relative
                    ]
                ]
                [ hr [] []
                , (sideQuestForm
                    { name = model.sideQuestName
                    , description = model.sideQuestDescription
                    , open = model.questFormOpen
                    , submitting = model.suggestingSideQuest
                    }
                  )
                , span [ class "flow-text" ] [ text "Care to propose a" ]
                , a
                    [ class "flow-text"
                    , css
                        [ cursor pointer
                        ]
                    , onClick
                        (if model.questFormOpen then
                            HideSideQuestForm
                         else
                            ShowSideQuestForm
                        )
                    ]
                    [ text " Side Quest " ]
                , span [ class "flow-text" ] [ text "for this adventurer to complete while on their journey?" ]
                ]
            ]
        , (if (List.length suggestedSideQuests) == 0 then
            div [] []
           else
            div
                [ css
                    [ marginTop (px 24)
                    ]
                ]
                [ (suggestedQuestsList
                    model.showingSuggestedSideQuests
                    suggestedSideQuests
                  )
                ]
          )
        , h3 [] [ text quest.name ]
        , div []
            [ (stepper
                { steps =
                    (List.map
                        (\sideQuest ->
                            { title = sideQuest.name
                            , description = sideQuest.description
                            }
                        )
                        sideQuests
                    )
                }
              )
            , (case model.decidingSideQuest of
                Just sideQuest ->
                    sideQuestDetails sideQuest

                Nothing ->
                    div [] []
              )
            ]
        ]


questDetailsView : Taco -> QuestDetailsModel -> Html QuestDetailsMsg
questDetailsView taco questDetails =
    let
        viewReady =
            Maybe.map3
                (\quest sideQuests suggestedSideQuests -> view quest sideQuests suggestedSideQuests questDetails)
                questDetails.quest
                questDetails.sideQuests
                questDetails.suggestedSideQuests
    in
        case viewReady of
            Just view ->
                view

            Nothing ->
                div []
                    [ h3 [] [ text "loading.." ]
                    ]
