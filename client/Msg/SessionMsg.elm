module Msg.SessionMsg exposing (SessionMsg, SessionMsg(..))

import Http
import Types exposing (..)


type SessionMsg
    = GetTokenResult (Result Http.Error String)
    | LoadSessionResult (Result Http.Error SessionInfo)
