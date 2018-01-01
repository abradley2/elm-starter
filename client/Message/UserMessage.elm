module Message.UserMessage exposing (UserMessage, UserMessage(..))

import Http


type UserMessage
    = GetTokenResult (Result Http.Error String)
