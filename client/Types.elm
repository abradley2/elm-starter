module Types exposing (..)


type alias SessionInfo =
    { username : String
    , userId : String
    }


type alias QuestInfo =
    { name : String
    , shortDescription : String
    , picture : String
    }


type alias Quest =
    { name : String
    , description : String
    , imageUrl : String
    , id : String
    }
