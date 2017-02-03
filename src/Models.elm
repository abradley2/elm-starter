module Models exposing (..)

import Home.Models exposing (HomeModel, home)


type alias Model =
    { home : HomeModel
    }


initialModel : Model
initialModel =
    { home = home
    }
