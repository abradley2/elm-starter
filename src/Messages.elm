module Messages exposing (..)

import Home.Messages


type Msg
    = AppMsg
    | HomeMsg Home.Messages.Msg
