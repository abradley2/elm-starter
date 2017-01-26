module Home.Models exposing (..)


type alias PersonId =
    String


type alias Person =
    { id : PersonId
    , name : String
    }


new : Person
new =
    { id = "0"
    , name = ""
    }
