module Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (Model)
import Home.Messages exposing (Msg(..))


view : Model -> Html Msg
view model =
    let
        home =
            model.home
    in
        div []
            [ h3 [] [ text home.message ]
            , input [ type_ "text", value home.message, onInput EditMessage ] []
            ]
