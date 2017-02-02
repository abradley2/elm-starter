module Ui.Update exposing (..)

import Ui.Messages exposing (Msg(..))
import Ui.Models exposing (UiModel)
import List exposing (..)
import Dict exposing (..)


update : Msg -> UiModel -> ( UiModel, Cmd Msg )
update message uiModel =
    case message of
        ToggleDropdown identifier ->
            ( { uiModel
                -- (comparable -> Maybe.Maybe v -> Maybe.Maybe v) Dict.Dict comparable v
                | dropdowns = Dict.update identifier (\_ -> Just True) uiModel.dropdowns
              }
            , Cmd.none
            )
