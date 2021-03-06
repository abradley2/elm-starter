module Page.MyAdventurer.View exposing (render)

import Page.MyAdventurer.Update exposing (..)
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Types exposing (Taco, RecentPostedQuest, TacoMsg(..))
import Component.TextField exposing (textField)
import Component.QuestCard exposing (questCardWithActionSection)
import Component.QuestAction exposing (questAction)


noQuests : Model -> Bool
noQuests model =
    List.length model.quests == 0


topCopy : Model -> Html Msg
topCopy model =
    if noQuests model then
        p [ class "flow-text" ]
            [ (text "it appears you don't have any quests...")
            , br [] []
            , a
                [ href "/newquest"
                , attribute "data-link" "/newquest"
                ]
                [ text "Let's create one!"
                ]
            ]
    else
        p [ class "flow-text" ]
            [ (text "Here are your active quests, adventurer!")
            , br [] []
            , a
                [ href "/newquest"
                , attribute "data-link" "/newquest"
                ]
                [ text "Perhaps you'd like to embark upon another?" ]
            ]


render : Taco -> Model -> Html Msg
render taco model =
    div [ class "container" ]
        [ topCopy model
        , div
            [ css
                [ displayFlex
                , flexWrap Css.wrap
                , alignItems Css.center
                ]
            ]
            (List.map
                (\quest ->
                    questCardWithActionSection quest
                        { showUserImage = False
                        , actionSection =
                            div []
                                [ (questAction
                                    { icon = "list"
                                    , text = "Details"
                                    , href = "details/" ++ quest.userId ++ ":" ++ quest.id
                                    }
                                  )
                                ]
                        }
                )
                model.quests
            )
        ]
