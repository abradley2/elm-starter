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
        , button [ onClick ToggleThing ] [ text "toggle thing" ]
        , if model.homeModel.toggle then
            h3 [ attribute "data-elm-lifecycle" "true" ] [ text "hi" ]
          else
            text ""
        , a [ href "#about" ] [ text "About Page" ]
        , input
            [ type_ "text"
            , value model.homeModel.greeting
            , onInput EditGreeting
            ]
            []
        ]
