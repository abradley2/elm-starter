module Types exposing (..)

import Navigation exposing (Location)


type Route
    = QuestsRoute
    | SideQuestsRoute String
    | MyAdventurerRoute
    | CreateQuestRoute
    | QuestDetailsRoute String
    | NotFoundRoute


type alias RouteData =
    ( Route, Location )


type alias Flags =
    { apiEndpoint : String
    }


type alias SessionModel =
    { flags : Flags
    , token : Maybe String
    , username : Maybe String
    , userId : Maybe String
    , routeData : RouteData
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


type alias SideQuest =
    { name : String
    , description : String
    , guid : String
    , suggestedBy : String
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


type alias QuestDetailsResponse =
    { quest : RecentPostedQuest
    , suggestedSideQuests : List SideQuest
    }


type alias GetSideQuestsResponse =
    { quest : RecentPostedQuest
    , sideQuests : List SideQuest
    }
