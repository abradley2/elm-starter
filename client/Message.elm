module Message exposing (Message, Message(..))

import Message.HomeMessage exposing (HomeMessage)
import Message.AboutMessage exposing (AboutMessage)


type Message
    = HomeMessage
    | AboutMessage