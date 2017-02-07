module View exposing (..)

import Html exposing (Html, div, text)
import Update exposing (Model, Msg(..))
import Pages.Home


view : Model -> Html Msg
view model =
    Html.map HomeMsg (Pages.Home.view model.home)
