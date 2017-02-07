module View exposing (..)

import Html exposing (Html, div, text)
import Update exposing (Model, Msg, Msg(..))
import Pages.Home


view : Model -> Html Msg
view model =
    Html.map Msg (Pages.Home.view model)
