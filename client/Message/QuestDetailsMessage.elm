module Message.QuestDetailsMessage exposing (QuestDetailsMessage, QuestDetailsMessage(..))

import Http
import Types exposing (QuestDetailsResponse, SideQuest)


type QuestDetailsMessage
    = NoOp
    | GetQuestDetailsResult (Result Http.Error QuestDetailsResponse)
    | DecideSideQuestResult (Result Http.Error QuestDetailsResponse)
    | ToggleShowingSuggestedSideQuests Bool
    | AcceptSuggestedSideQuest
    | DeclineSuggestedSideQuest
    | ToggleShowingSideQuestModal (Maybe SideQuest)
    | AcceptSideQuest String
    | DeclineSideQuest String
