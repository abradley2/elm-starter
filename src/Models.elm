module Models exposing (..)

import Home.Models exposing (HomeModel, home)


type alias Taco =
    { tacoMessage : String
    }


type alias Model =
    { home : HomeModel
    , taco : Taco
    }


taco : Taco
taco =
    { tacoMessage = "I am a Taco"
    }


initialModel : Model
initialModel =
    { home = home
    , taco = taco
    }
