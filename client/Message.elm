module Message exposing (Message, Message(..))

import Navigation exposing (Location)
import Message.QuestsMessage exposing (QuestsMessage)
import Message.SideQuestsMessage exposing (SideQuestsMessage)
import Message.LayoutMessage exposing (LayoutMessage)
import Message.SessionMessage exposing (SessionMessage)
import Message.MyAdventurerMessage exposing (MyAdventurerMessage)
import Message.CreateQuestMessage exposing (CreateQuestMessage)
import Message.QuestDetailsMessage exposing (QuestDetailsMessage)
import Types exposing (..)


type Message
    = Mount ( String, String )
    | Unmount ( String, String )
    | UploadQuestImageFinished ( Bool, String )
    | LoadQuestId String
    | LoadQuestStepId ( String, String )
    | LoadToken String
    | OnLocationChange Location
    | Quests QuestsMessage
    | SideQuests SideQuestsMessage
    | Layout LayoutMessage
    | Session SessionMessage
    | MyAdventurer MyAdventurerMessage
    | CreateQuest CreateQuestMessage
    | QuestDetails QuestDetailsMessage
