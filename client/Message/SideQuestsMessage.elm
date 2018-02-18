module Message.SideQuestsMessage exposing (SideQuestsMessage, SideQuestsMessage(..))

import Types exposing (SideQuest, GetSideQuestsResponse)
import Http


type SideQuestsMessage
    = AddNewSideQuest
    | GetSideQuestsResult (Result Http.Error GetSideQuestsResponse)
    | NoOp
