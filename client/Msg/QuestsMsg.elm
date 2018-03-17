module Msg.QuestsMsg exposing (QuestsMsg, QuestsMsg(..))

import Types exposing (RecentPostedQuest)
import Http


type QuestsMsg
    = NoOp
    | GetQuestsResult (Result Http.Error (List RecentPostedQuest))
