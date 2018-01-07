module View.QuestsView exposing (questsView)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.QuestsMessage exposing (QuestsMessage, QuestsMessage(..))


questsView : Model -> Html QuestsMessage
questsView model =
    div
        [ css
            [ padding4 (px 16) (px 8) (px 0) (px 8) ]
        ]
        [ input
            [ value model.quests.newQuestName
            , onInput EditNewQuestName
            , attribute "data-elm-lifecycle" "newArmyTextField"
            , attribute "data-js-component" "textField"
            , type_ "text"
            ]
            []
        , span
            [ class "btn"
            , onClick
                (if model.quests.newQuestName /= "" then
                    AddNewQuest
                 else
                    NoOp
                )
            ]
            [ i [ class "material-icons left" ] [ text "add" ]
            , text "Add Quest"
            ]
        , div []
            (List.map
                (\quest ->
                    div
                        []
                        [ text quest ]
                )
                model.quests.questList
            )
        ]
