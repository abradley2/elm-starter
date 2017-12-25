module View.AboutView exposing (aboutView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model)
import Message.AboutMessage exposing (AboutMessage)


aboutView : Model -> Html AboutMessage
aboutView model =
    div [ class "center measure" ]
        [ a [ href "#" ] [ text "Home" ]
        , h3 [] [ text "About Page" ]
        ]
