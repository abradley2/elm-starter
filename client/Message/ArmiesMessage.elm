module Message.ArmiesMessage exposing (ArmiesMessage, ArmiesMessage(..))

import Http


type ArmiesMessage
    = NoOp
    | GetArmiesResult (Result Http.Error (List String))
