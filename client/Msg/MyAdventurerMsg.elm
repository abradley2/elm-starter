module Msg.MyAdventurerMsg exposing (MyAdventurerMsg, MyAdventurerMsg(..))

import Http
import Types exposing (RecentPostedQuest)


type MyAdventurerMsg
    = NoOp
    | GetQuestsByUserResult (Result Http.Error (List RecentPostedQuest))
