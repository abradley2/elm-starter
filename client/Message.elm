module Message exposing (Message, Message(..))

import Navigation exposing (Location)
import Message.QuestsMessage exposing (QuestsMessage)
import Message.SideQuestsMessage exposing (SideQuestsMessage)
import Message.LayoutMessage exposing (LayoutMessage)
import Message.SessionMessage exposing (SessionMessage)


type Message
    = Mount ( String, String )
    | Unmount ( String, String )
    | OnLocationChange Location
    | Quests QuestsMessage
    | SideQuests SideQuestsMessage
    | Layout LayoutMessage
    | Session SessionMessage
