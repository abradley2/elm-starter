module Message exposing (Message, Message(..))

import Navigation exposing (Location)
import Message.ArmiesMessage exposing (ArmiesMessage)
import Message.UnitsMessage exposing (UnitsMessage)
import Message.LayoutMessage exposing (LayoutMessage)


type Message
    = Mount String
    | Unmount String
    | OnLocationChange Location
    | Armies ArmiesMessage
    | Units UnitsMessage
    | Layout LayoutMessage
