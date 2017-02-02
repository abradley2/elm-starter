module Models exposing (..)

import Home.Models exposing (HomeModel, home)
import Ui.Models exposing (UiModel, ui)


type alias Model =
    { home : HomeModel
    , ui : UiModel
    }


initialModel : Model
initialModel =
    { home = home
    , ui = ui
    }
