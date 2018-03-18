module Msg exposing (Msg, Msg(..))

import Navigation exposing (Location)
import Msg.QuestsMsg exposing (QuestsMsg)
import Msg.SideQuestsMsg exposing (SideQuestsMsg)
import Msg.LayoutMsg exposing (LayoutMsg)
import Msg.SessionMsg exposing (SessionMsg)
import Msg.MyAdventurerMsg exposing (MyAdventurerMsg)
import Msg.CreateQuestMsg exposing (CreateQuestMsg)
import Msg.QuestDetailsMsg exposing (QuestDetailsMsg)
import Types exposing (..)


type Msg
    = Mount ( String, String )
    | Unmount ( String, String )
    | LoadQuestId String
    | UploadQuestImageFinished ( Bool, String )
    | LoadToken String
    | OnLocationChange Location
    | Quests QuestsMsg
    | SideQuests SideQuestsMsg
    | Layout LayoutMsg
    | Session SessionMsg
    | MyAdventurer MyAdventurerMsg
    | CreateQuest CreateQuestMsg
    | QuestDetails QuestDetailsMsg


type Cmds
    = List (Cmd Msg)
