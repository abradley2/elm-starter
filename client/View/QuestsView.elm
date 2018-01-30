module View.QuestsView exposing (questsView)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.QuestsMessage exposing (QuestsMessage, QuestsMessage(..))
import Component.TextField exposing (textField)


questsView : Model -> Html QuestsMessage
questsView model =
    div
        [ css
            [ padding4 (px 16) (px 8) (px 0) (px 8) ]
        ]
        [ (case model.session.userId of
            Just userId ->
                div []
                    [ img [ src ("https://graph.facebook.com/" ++ userId ++ "/picture?type=small") ] []
                    ]

            Nothing ->
                div [] []
          )
        ]
