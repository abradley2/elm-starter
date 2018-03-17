module Msg.SideQuestsMsg exposing (SideQuestsMsg, SideQuestsMsg(..))

import Types exposing (SideQuest, GetSideQuestsResponse)
import Http


type SideQuestsMsg
    = GetSideQuestsResult (Result Http.Error GetSideQuestsResponse)
    | ShowSideQuestForm
    | HideSideQuestForm
    | SubmitSideQuestForm
    | SuggestSideQuestResult (Result Http.Error Bool)
    | EditSideQuestName String
    | EditSideQuestDescription String
    | NoOp
