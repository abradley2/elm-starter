module Message.SideQuestsMessage exposing (SideQuestsMessage, SideQuestsMessage(..))

import Types exposing (SideQuest, GetSideQuestsResponse)
import Http


type SideQuestsMessage
    = GetSideQuestsResult (Result Http.Error GetSideQuestsResponse)
    | ShowSideQuestForm
    | HideSideQuestForm
    | SubmitSideQuestForm
    | SuggestSideQuestResult (Result Http.Error Bool)
    | EditSideQuestName String
    | EditSideQuestDescription String
    | NoOp
