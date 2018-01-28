module Message.CreateQuestMessage exposing (CreateQuestMessage, CreateQuestMessage(..))


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
