module View.CreateQuestView exposing (createQuestView)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.CreateQuestMessage exposing (CreateQuestMessage, CreateQuestMessage(..))
import Component.TextField exposing (textField)


helperText =
    """
A quest can be many things. A traveling to a cool new places with a set of activities
and places to see in mind.

Or it can be self improvement. The quest could be 30 continual days of working out
and lifting weights. with the end goal of +2 to your strength and dexterity stats.

Either way, be perscriptive! A quest you complete should be helpful to others who
want guidance on how to go about something.
"""


createQuestView : Model -> Html CreateQuestMessage
createQuestView model =
    div [ class "container" ]
        [ p [ class "flow-text" ]
            [ (text helperText)
            , br [] []
            , a
                [ href "#newquest"
                ]
                [ text "Let's create one!"
                ]
            ]
        ]
