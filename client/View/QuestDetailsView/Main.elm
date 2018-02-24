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
import Component.Stepper exposing (stepper)
import Types exposing (RecentPostedQuest, SideQuest)


view : RecentPostedQuest -> List SideQuest -> Model -> Html QuestDetailsMessage
view quest suggestedSideQuests model =
    div [ class "container" ]
        [ h3 [] [ text quest.name ]
        , div []
            [ (stepper
                { steps =
                    (List.map
                        (\sideQuest ->
                            { title = sideQuest.name
                            , description = sideQuest.description
                            }
                        )
                        suggestedSideQuests
                    )
                }
              )
            ]
        ]


questDetailsView : Model -> Html QuestDetailsMessage
questDetailsView model =
    let
        viewReady =
            Maybe.map2
                (\quest suggestedSideQuests -> view quest suggestedSideQuests model)
                model.questDetails.quest
                model.questDetails.suggestedSideQuests
    in
        case viewReady of
            Just view ->
                view

            Nothing ->
                div []
                    [ h3 [] [ text "loading.." ]
                    ]
