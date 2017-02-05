module Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (Taco, Model)
import Home.Messages exposing (Msg(..))


view : Taco -> Model -> Html Msg
view taco model =
    let
        home =
            model.home
    in
        div []
            [ h3 [] [ text home.message ]
            , input [ type_ "text", value home.message, onInput EditMessage ] []
            , hr [] []
            , h3 [] [ text taco.message ]
            , input [ type_ "text", value taco.message, onInput EditTacoMessage ] []
            ]
