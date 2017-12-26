module Message exposing (Message, Message(..))

import Navigation exposing (Location)
import Message.HomeMessage exposing (HomeMessage)
import Message.AboutMessage exposing (AboutMessage)
import Message.LayoutMessage exposing (LayoutMessage)


type Message
    = Mount String
    | Unmount String
    | OnLocationChange Location
    | Home HomeMessage
    | About AboutMessage
    | Layout LayoutMessage
