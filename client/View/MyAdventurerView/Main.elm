module View.MyAdventurerView.Main exposing (myAdventurerView)

import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Types exposing (Taco)
import Update.MyAdventurerUpdate exposing (MyAdventurerModel, MyAdventurerMsg, MyAdventurerMsg(..))
import Component.TextField exposing (textField)
import Component.QuestCard exposing (questCardWithActionSection)
import Component.QuestAction exposing (questAction)


noQuests : MyAdventurerModel -> Bool
noQuests model =
    List.length model.quests == 0


topCopy : MyAdventurerModel -> Html MyAdventurerMsg
topCopy model =
    if noQuests model then
        p [ class "flow-text" ]
            [ (text "it appears you don't have any quests...")
            , br [] []
            , a
                [ href "#newquest"
                ]
                [ text "Let's create one!"
                ]
            ]
    else
        p [ class "flow-text" ]
            [ (text "Here are your active quests, adventurer!")
            , br [] []
            , a [ href "#newquest" ] [ text "Perhaps you'd like to embark upon another?" ]
            ]


myAdventurerView : Taco -> MyAdventurerModel -> Html MyAdventurerMsg
myAdventurerView taco model =
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
                                    , href = "#details/" ++ quest.userId ++ ":" ++ quest.id
                                    }
                                  )
                                ]
                        }
                )
                model.quests
            )
        ]
