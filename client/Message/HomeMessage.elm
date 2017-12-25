module Message.HomeMessage exposing (HomeMessage, HomeMessage(..))


type HomeMessage
    = NoOp
    | EditGreeting String
