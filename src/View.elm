module View exposing (..)

import Html exposing (Html, div, text)
import Update exposing (Model, Msg)
import Pages.Home


view : Model -> Html Msg
view model =
    div []
        [ page model ]


page : Model -> Html Msg
page model =
    Html.map HomeMsg (Pages.Home.view model.taco model)
