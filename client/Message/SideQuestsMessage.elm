module Message.SideQuestsMessage exposing (SideQuestsMessage, SideQuestsMessage(..))

import Types exposing (SideQuest)
import Http


type SideQuestsMessage
    = AddNewSideQuest
    | GetSideQuestsResult (Result Http.Error (List SideQuest))
