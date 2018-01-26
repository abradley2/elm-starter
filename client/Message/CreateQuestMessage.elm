module Message.CreateQuestMessage exposing (CreateQuestMessage, CreateQuestMessage(..))


type CreateQuestMessage
    = NoOp
    | AddQuestStep
    | EditQuestStepName String String
    | EditQuestStepDescription String String
    | DeleteQuestStepPrompt String
    | DeleteQuestStepConfirm
    | DeleteQuestStepCancel
    | ShowFileUploadModal String
