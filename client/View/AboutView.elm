module View.AboutView exposing (aboutView)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Model exposing (Model)
import Message exposing (Message)


aboutView : Model -> Html Message
aboutView model =
    div [ class "center measure" ]
        [ h3 [] [ text "About Page" ]
        ]
