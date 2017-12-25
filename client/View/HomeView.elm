module View.HomeView exposing (homeView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model)
import Message.HomeMessage exposing (HomeMessage, HomeMessage(..))


homeView : Model -> Html HomeMessage
homeView model =
    div [ class "center measure" ]
        [ h3 [] [ text model.homeModel.greeting ]
        , input
            [ type_ "text"
            , value model.homeModel.greeting
            , onInput EditGreeting
            ]
            []
        ]
