module Message exposing (Message, Message(..))

import Navigation exposing (Location)
import Message.HomeMessage exposing (HomeMessage)
import Message.UnitsMessage exposing (UnitsMessage)
import Message.LayoutMessage exposing (LayoutMessage)


type Message
    = Mount String
    | Unmount String
    | OnLocationChange Location
    | Home HomeMessage
    | Units UnitsMessage
    | Layout LayoutMessage
