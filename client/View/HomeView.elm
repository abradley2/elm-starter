module View.HomeView exposing (homeView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model)
import Message exposing (Message)


homeView : Model -> Html Message
homeView model =
    div [ class "center measure" ]
        [ h3 [] [ text model.greeting ]
        , input
            [ type_ "text"
            , value model.greeting
            , onInput EditMsg
            ]
            []
        ]
