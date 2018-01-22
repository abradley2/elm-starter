module View.MyAdventurerView exposing (myAdventurerView)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.MyAdventurerMessage exposing (MyAdventurerMessage, MyAdventurerMessage(..))
import Component.TextField exposing (textField)


myAdventurerView : Model -> Html MyAdventurerMessage
myAdventurerView model =
    div [ class "container" ]
        [ p [ class "flow-text" ]
            [ (text "It appears you don't have any quests... ")
            , br [] []
            , a
                [ href "#newquest"
                ]
                [ text "Let's create one!"
                ]
            ]
        ]
