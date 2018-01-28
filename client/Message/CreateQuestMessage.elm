module Message.CreateQuestMessage exposing (CreateQuestMessage, CreateQuestMessage(..))

import Http
import Types exposing (Quest)


type CreateQuestMessage
    = NoOp
    | AddQuestStep
    | EditQuestName String
    | EditQuestDescription String
    | EditQuestStepName String String
    | EditQuestStepDescription String String
    | DeleteQuestStepPrompt String
    | DeleteQuestStepConfirm
    | DeleteQuestStepCancel
    | ShowFileUploadModal String
    | HideFileUploadModal
    | OnFileChosen String
    | ConfirmFileUpload String
    | SubmitCreateQuest
    | SubmitCreateQuestResult (Result Http.Error Quest)
