module View.MyAdventurerView.Main exposing (myAdventurerView)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.MyAdventurerMessage exposing (MyAdventurerMessage, MyAdventurerMessage(..))
import Component.TextField exposing (textField)
import Component.QuestCard exposing (questCard)


noQuests : Model -> Bool
noQuests model =
    List.length model.myAdventurer.quests == 0


topCopy : Model -> Html MyAdventurerMessage
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
            [ (text "Here are you active quests, adventurer!")
            , br [] []
            , a [ href "#newquest" ] [ text "Perhaps you'd like to embark upon another?" ]
            ]


myAdventurerView : Model -> Html MyAdventurerMessage
myAdventurerView model =
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
                (\quest -> questCard quest { showUserImage = False })
                model.myAdventurer.quests
            )
        ]
