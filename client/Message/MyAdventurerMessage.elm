module Message.MyAdventurerMessage exposing (MyAdventurerMessage, MyAdventurerMessage(..))

import Http
import Types exposing (RecentPostedQuest)


type MyAdventurerMessage
    = NoOp
    | GetQuestsByUserResult (Result Http.Error (List RecentPostedQuest))
