module Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Home.Messages exposing (..)
import Models exposing (Model)
import Ui.Components exposing (getDropdown)


view : Model -> Html Msg
view model =
    div []
        [ input [ value model.home.message, onInput EditMessage ] []
        , getDropdown "my-dropdown" model
        ]
