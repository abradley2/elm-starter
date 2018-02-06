module Types exposing (..)


type alias Flags =
    { apiEndpoint : String
    }


type alias SessionModel =
    { flags : Flags
    , token : Maybe String
    , username : Maybe String
    , userId : Maybe String
    }


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


type alias RecentPostedQuest =
    { name : String
    , description : String
    , imageUrl : String
    , id : String
    , guid : String
    , username : String
    , userId : String
    , upvotes : Int
    }
