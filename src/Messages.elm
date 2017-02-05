module Messages exposing (Msg(..), TacoMsg(..))

import Home.Messages


type TacoMsg
    = NoOp


type Msg
    = HomeMsg Home.Messages.Msg
