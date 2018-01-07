module View.ArmiesView exposing (armiesView)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Model exposing (Model)
import Message.ArmiesMessage exposing (ArmiesMessage, ArmiesMessage(..))


armiesView : Model -> Html ArmiesMessage
armiesView model =
    div
        [ css
            [ padding4 (px 16) (px 8) (px 0) (px 8) ]
        ]
        [ input
            [ value model.armies.newArmyName
            , attribute "data-elm-lifecycle" "newArmyTextField"
            , attribute "data-js-component" "textField"
            , type_ "text"
            ]
            []
        , span
            [ class "btn"
            , onClick
                (if model.armies.newArmyName /= "" then
                    AddNewArmy
                 else
                    NoOp
                )
            ]
            [ i [ class "material-icons left" ] [ text "add" ]
            , text "Add Army"
            ]
        , div []
            (List.map
                (\army ->
                    div
                        []
                        [ text army ]
                )
                model.armies.armyList
            )
        ]