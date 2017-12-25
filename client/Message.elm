module Message exposing (Message, Message(..))

import Navigation exposing (Location)
import Message.HomeMessage exposing (HomeMessage)
import Message.AboutMessage exposing (AboutMessage)


type Message
    = OnLocationChange Location
    | Home HomeMessage
    | About AboutMessage
