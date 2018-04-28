module Page.QuestDetails.View exposing (render)

import Page.QuestDetails.Update exposing (..)
import Theme
import Http
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Component.Stepper exposing (stepper)
import Page.QuestDetails.Update exposing (..)
import Page.QuestDetails.SuggestedQuestsList exposing (suggestedQuestsList)
import Page.QuestDetails.SideQuestDetails exposing (sideQuestDetails)
import Page.QuestDetails.SideQuestForm exposing (sideQuestForm)
import Types exposing (TacoMsg, TacoMsg(..), RecentPostedQuest, SideQuest, Taco, QuestDetailsResponse)


loadedView : RecentPostedQuest -> List SideQuest -> List SideQuest -> Model -> Html Msg
loadedView quest sideQuests suggestedSideQuests model =
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


render : Taco -> Model -> Html Msg
render taco model =
    let
        viewReady =
            Maybe.map3
                (\quest sideQuests suggestedSideQuests -> loadedView quest sideQuests suggestedSideQuests model)
                model.quest
                model.sideQuests
                model.suggestedSideQuests
    in
        case viewReady of
            Just view ->
                view

            Nothing ->
                div []
                    [ h3 [] [ text "loading.." ]
                    ]
