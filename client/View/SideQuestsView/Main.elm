module View.SideQuestsView.Main exposing (sideQuestsView)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Msg.SideQuestsMsg exposing (SideQuestsMsg, SideQuestsMsg(..))
import Model exposing (Model)
import Theme
import Types exposing (RecentPostedQuest, SideQuest)
import View.SideQuestsView.SideQuestForm exposing (sideQuestForm)


ready : Model -> RecentPostedQuest -> List SideQuest -> Html SideQuestsMsg
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
                    { name = model.sideQuests.sideQuestName
                    , description = model.sideQuests.sideQuestDescription
                    , open = model.sideQuests.questFormOpen
                    , submitting = model.sideQuests.suggestingSideQuest
                    }
                  )
                , span [ class "flow-text" ] [ text "Care to propose a" ]
                , a
                    [ class "flow-text"
                    , css
                        [ cursor pointer
                        ]
                    , onClick
                        (if model.sideQuests.questFormOpen then
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


loading : Html SideQuestsMsg
loading =
    div [ class "container" ]
        [ p [ class "flow-text" ] [ text "...loading" ]
        ]


sideQuestsView : Model -> Html SideQuestsMsg
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
