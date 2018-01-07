module Message.QuestsMessage exposing (QuestsMessage, QuestsMessage(..))

import Http


type QuestsMessage
    = NoOp
    | EditNewQuestName String
    | AddNewQuest
    | GetQuestsResult (Result Http.Error (List String))
