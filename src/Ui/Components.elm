module Ui.Components exposing (..)

import Ui.Messages exposing (Msg(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Models exposing (Model)
import Dict exposing (..)
import String exposing (..)


getDropdown : String -> Model -> Html Msg
getDropdown identifier model =
    let
        open =
            case (Dict.get identifier model.ui.dropdowns) of
                Just open ->
                    open

                Nothing ->
                    False
    in
        div
            [ class
                (append
                    (if open then
                        "open"
                     else
                        ""
                    )
                    "dropdown "
                )
            ]
            [ button [ onClick (ToggleDropdown identifier), class "btn btn-default dropdown-toggle", type_ "button" ] [ text "open dropdown" ]
            , ul [ class "dropdown-menu" ]
                [ li []
                    [ a [ href "#" ] [ text "It's open!" ]
                    ]
                ]
            ]
