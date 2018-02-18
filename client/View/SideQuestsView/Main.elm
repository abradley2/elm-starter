module View.SideQuestsView.Main exposing (sideQuestsView)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Message.SideQuestsMessage exposing (SideQuestsMessage, SideQuestsMessage(..))
import Model exposing (Model)
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


ready : Model -> RecentPostedQuest -> List SideQuest -> Html SideQuestsMessage
ready model quest sideQuests =
    div [ class "container" ]
        [ div []
            [ h4 [] [ text quest.name ]
            , p [ class "flow-text" ] [ text "Sidequests" ]
            ]
        ]


loading : Html SideQuestsMessage
loading =
    div [ class "container" ]
        [ p [ class "flow-text" ] [ text "...loading" ]
        ]


sideQuestsView : Model -> Html SideQuestsMessage
sideQuestsView model =
    let
        isLoaded =
            (Maybe.map2 (ready model)
                model.sideQuests.questInfo
                model.sideQuests.sideQuestList
            )
    in
        case isLoaded of
            Nothing ->
                loading

            Just view ->
                view
