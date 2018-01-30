module Message.QuestsMessage exposing (QuestsMessage, QuestsMessage(..))

import Types exposing (RecentPostedQuest)
import Http


type QuestsMessage
    = NoOp
    | GetQuestsResult (Result Http.Error (List RecentPostedQuest))
