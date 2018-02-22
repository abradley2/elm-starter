module Message.SideQuestsMessage exposing (SideQuestsMessage, SideQuestsMessage(..))

import Types exposing (SideQuest, GetSideQuestsResponse)
import Http


type SideQuestsMessage
    = GetSideQuestsResult (Result Http.Error GetSideQuestsResponse)
    | ShowSideQuestForm
    | HideSideQuestForm
    | SubmitSideQuestForm
    | EditSideQuestName String
    | EditSideQuestDescription String
    | NoOp
