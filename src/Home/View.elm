module Home.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Messages exposing (Msg(..))
import Models exposing (Model)


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text "Hello World!" ]
        ]
