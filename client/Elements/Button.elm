module Elements.Button exposing (button)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


type alias Handlers uid msg =
    { uid : uid
    , onclick : msg -> uid
    }


button : Handlers uid msg -> Html msg
button handlers =
    span [ onClick handlers.onclick ] [ text "click me" ]
