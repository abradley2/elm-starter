module View.SideQuestsView.Main exposing (sideQuestsView)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Update.SideQuestsUpdate exposing (SideQuestsModel, SideQuestsMsg, SideQuestsMsg(..))
import Theme
import Types exposing (Taco, RecentPostedQuest, SideQuest)
import View.SideQuestsView.SideQuestForm exposing (sideQuestForm)


ready : SideQuestsModel -> RecentPostedQuest -> List SideQuest -> Html SideQuestsMsg
ready model quest sideQuests =
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
        ]


loadingIndicator : Html SideQuestsMsg
loadingIndicator =
    div [ class "container" ]
        [ p [ class "flow-text" ] [ text "...loading" ]
        ]


sideQuestsView : Taco -> SideQuestsModel -> Html SideQuestsMsg
sideQuestsView taco model =
    let
        isLoaded =
            (Maybe.map2 (ready model)
                model.questInfo
                model.sideQuestList
            )
    in
        case isLoaded of
            Nothing ->
                loadingIndicator

            Just view ->
                view
