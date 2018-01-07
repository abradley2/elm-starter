module Message.QuestsMessage exposing (QuestsMessage, QuestsMessage(..))

import Http


type QuestsMessage
    = NoOp
    | EditNewArmyName String
    | AddNewArmy
    | GetArmiesResult (Result Http.Error (List String))
