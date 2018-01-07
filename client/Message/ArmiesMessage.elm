module Message.ArmiesMessage exposing (ArmiesMessage, ArmiesMessage(..))

import Http


type ArmiesMessage
    = NoOp
    | EditNewArmyName String
    | AddNewArmy
    | GetArmiesResult (Result Http.Error (List String))
