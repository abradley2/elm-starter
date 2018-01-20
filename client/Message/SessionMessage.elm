module Message.SessionMessage exposing (SessionMessage, SessionMessage(..))

import Http
import Types exposing (..)


type SessionMessage
    = GetTokenResult (Result Http.Error String)
    | LoadSessionResult (Result Http.Error SessionInfo)
