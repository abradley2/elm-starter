module Types exposing (..)

import Navigation exposing (Location)


type alias Flags =
    { apiEndpoint : String
    }


type TacoMsg
    = TacoNoOp
    | UserLoggedIn
    | UserLoggedout
      -- Routes
    | QuestsRoute
    | SideQuestsRoute String
    | MyAdventurerRoute
    | CreateQuestRoute
    | QuestDetailsRoute String
    | NotFoundRoute


type alias RouteData =
    ( TacoMsg, Location )


type alias Taco =
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
    , sideQuests : List SideQuest
    , suggestedSideQuests : List SideQuest
    }


type alias GetSideQuestsResponse =
    { quest : RecentPostedQuest
    , sideQuests : List SideQuest
    }
