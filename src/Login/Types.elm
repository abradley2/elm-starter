module Login.Types exposing (..)


type alias LoginModel =
    { username : String
    , password : String
    }


type LoginMsg
    = EDIT_USERNAME String
    | EDIT_PASSWORD String
