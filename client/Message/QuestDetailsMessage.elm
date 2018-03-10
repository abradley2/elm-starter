module Message.QuestDetailsMessage exposing (QuestDetailsMessage, QuestDetailsMessage(..))

import Http
import Types exposing (QuestDetailsResponse)


type QuestDetailsMessage
    = NoOp
    | GetQuestDetailsResult (Result Http.Error QuestDetailsResponse)
    | DecideSideQuestResult (Result Http.Error QuestDetailsResponse)
    | ToggleShowingSuggestedSideQuests Bool
    | AcceptSuggestedSideQuest String
    | DeclineSuggestedSideQuest String
    | ToggleShowingSideQuestModal Bool
    | AcceptSideQuest String
    | DeclineSideQuest String
