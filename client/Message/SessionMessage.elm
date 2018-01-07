module Message.SessionMessage exposing (SessionMessage, SessionMessage(..))

import Http


type SessionMessage
    = GetTokenResult (Result Http.Error String)
