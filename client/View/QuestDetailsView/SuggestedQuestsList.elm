module View.QuestDetailsView.SuggestedQuestsList exposing (suggestedQuestsList)

import Html
import Array
import Theme
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Msg.QuestDetailsMsg exposing (QuestDetailsMsg, QuestDetailsMsg(..))
import Types exposing (RecentPostedQuest, SideQuest)


suggestedQuestsList : Bool -> List SideQuest -> Html QuestDetailsMsg
suggestedQuestsList isOpen sideQuests =
    div []
        [ a
            [ class "flow-text"
            , onClick (ToggleShowingSuggestedSideQuests (not isOpen))
            , css
                [ cursor pointer
                , display block
                ]
            ]
            [ span
                [ css
                    [ paddingRight (px 12)
                    ]
                ]
                [ i [ class "fa fa-envelope" ] [] ]
            , span [] [ text "Thou hath mail!" ]
            , span
                [ css
                    [ paddingLeft (px 12)
                    , display inlineBlock
                    , transform
                        (rotateX
                            (if isOpen then
                                deg 180
                             else
                                deg 0
                            )
                        )
                    ]
                , style [ ( "transition", "0.5s" ) ]
                ]
                [ i
                    [ class "fa fa-caret-up"
                    ]
                    []
                ]
            ]
        , div
            [ css
                [ position relative
                , marginTop (px 16)
                ]
            ]
            [ div
                [ css
                    [ position absolute
                    , zIndex (int 100)
                    , backgroundColor Theme.white
                    , left (px 0)
                    , right (px 0)
                    , overflow Css.hidden
                    , Css.height
                        (if isOpen then
                            (px 400)
                         else
                            (px 0)
                        )
                    ]
                , style [ ( "transition", ".3s" ), ( "box-shadow", Theme.cardBoxShadow ) ]
                ]
                [ ul
                    [ class "collection"
                    , style [ ( "margin", "0px" ) ]
                    ]
                    (List.map
                        (\sideQuest ->
                            li
                                [ class "collection-item avatar"
                                , onClick (ToggleShowingSideQuestModal (Just sideQuest))
                                , css
                                    [ cursor pointer
                                    ]
                                ]
                                [ img
                                    [ src ("https://graph.facebook.com/" ++ sideQuest.suggestedBy ++ "/picture?type=small")
                                    , class "circle"
                                    , css
                                        [ Css.height (px 50)
                                        , Css.width (px 50)
                                        ]
                                    ]
                                    []
                                , span
                                    [ class "title"
                                    , css
                                        [ fontWeight bolder
                                        ]
                                    ]
                                    [ text sideQuest.name ]
                                , p [] [ text sideQuest.description ]
                                , span [ class "secondary-content" ]
                                    [ i [ class "fa fa-envelope" ] []
                                    ]
                                ]
                        )
                        sideQuests
                    )
                ]
            ]
        ]
