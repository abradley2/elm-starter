module View exposing (..)

import Html exposing (Html, div, text)
import Messages exposing (Msg(..))
import Models exposing (Model)
import Home.View


view : Model -> Html AppMsg
view model =
    div []
        [ page model ]


page : Model -> Html AppMsg
page model =
    Html.map AppMsg (Home.View.view model)
