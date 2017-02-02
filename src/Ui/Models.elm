module Ui.Models exposing (..)

import Dict exposing (..)


type alias UiModel =
    { dropdowns : Dict String Bool
    }


ui : UiModel
ui =
    { dropdowns = Dict.empty
    }
