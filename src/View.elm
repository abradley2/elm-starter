module View exposing (rootView)

import Types exposing (Msg, Model)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Login.View exposing (loginView)


rootView : Model -> Html Msg
rootView model =
    div
        [ class "container" ]
        [ loginView model ]
