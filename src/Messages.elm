module Messages exposing (Msg(..), TacoMsg(..))

import Home.Messages


type TacoMsg
    = NoOp_
    | EditMessage_ String


type Msg
    = HomeMsg Home.Messages.Msg
