module Msg.CreateQuestMsg exposing (CreateQuestMsg, CreateQuestMsg(..))

import Http
import Types exposing (Quest)


type CreateQuestMsg
    = NoOp
    | AddQuestStep
    | EditQuestName String
    | EditQuestDescription String
    | EditQuestStepName String String
    | EditQuestStepDescription String String
    | DeleteQuestStepPrompt String
    | DeleteQuestStepConfirm
    | DeleteQuestStepCancel
    | ShowFileUploadModal
    | HideFileUploadModal
    | OnFileChosen String
    | ConfirmFileUpload String
    | SubmitCreateQuest
    | SubmitCreateQuestResult (Result Http.Error Quest)
