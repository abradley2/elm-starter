module Models exposing (..)

import Home.Models exposing (Person)


type alias Model =
    { people : List Person
    }


initialModel : Model
initialModel =
    { people = [ Person "1" "Tony" ]
    }
