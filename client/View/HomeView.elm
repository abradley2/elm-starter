module View.HomeView exposing (homeView)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.HomeMessage exposing (HomeMessage, HomeMessage(..))


homeView : Model -> Html HomeMessage
homeView model =
    div [ class "center measure" ]
        [ h3 [] [ text "test" ]
        ]
