module View.AboutView exposing (aboutView)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.AboutMessage exposing (AboutMessage)


aboutView : Model -> Html AboutMessage
aboutView model =
    div [ class "center measure" ]
        [ a [ href "#" ] [ text "Home" ]
        , h3 [] [ text "About Page" ]
        ]
