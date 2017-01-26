module Home.Models exposing (..)


type alias PersonId =
    String


type alias Person =
    { id : PersonId
    , name : String
    }

type alias HomeModel =
    { people : List Person
    , newName : String
    }

home : HomeModel
home =
    { people =
        [ { id = "0", name = "Tony" }
        ]
    , newName = "New Person"
    }
