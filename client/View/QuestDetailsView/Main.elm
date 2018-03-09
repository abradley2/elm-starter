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
import View.QuestDetailsView.SuggestedQuestsList exposing (suggestedQuestsList)
import Types exposing (RecentPostedQuest, SideQuest)


{-
   <ul class="collection">
      <li class="collection-item avatar">
        <img src="images/yuna.jpg" alt="" class="circle">
        <span class="title">Title</span>
        <p>First Line <br>
           Second Line
        </p>
        <a href="#!" class="secondary-content"><i class="material-icons">grade</i></a>
      </li>
-}


view : RecentPostedQuest -> List SideQuest -> List SideQuest -> Model -> Html QuestDetailsMessage
view quest sideQuests suggestedSideQuests model =
    div [ class "container" ]
        [ (if (List.length suggestedSideQuests) == 0 then
            div [] []
           else
            div
                [ css
                    [ marginTop (px 24)
                    ]
                ]
                [ (suggestedQuestsList
                    model.questDetails.showingSuggestedSideQuests
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
            ]
        ]


questDetailsView : Model -> Html QuestDetailsMessage
questDetailsView model =
    let
        viewReady =
            Maybe.map3
                (\quest sideQuests suggestedSideQuests -> view quest sideQuests suggestedSideQuests model)
                model.questDetails.quest
                model.questDetails.sideQuests
                model.questDetails.suggestedSideQuests
    in
        case viewReady of
            Just view ->
                view

            Nothing ->
                div []
                    [ h3 [] [ text "loading.." ]
                    ]
