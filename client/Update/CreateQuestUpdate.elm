module Update.CreateQuestUpdate
    exposing
        ( onUpdate
        , createQuestInitialModel
        , CreateQuestModel
        , CreateQuestMsg
        , CreateQuestMsg(..)
        )

import Navigation
import Html.Attributes exposing (name)
import Request.CreateQuestRequest exposing (createQuestRequest)
import Ports exposing (uploadQuestImage)
import Types exposing (Quest, Taco, TacoMsg(..))
import Array
import Http


type CreateQuestMsg
    = NoOp
    | EditQuestName String
    | EditQuestDescription String
    | ShowFileUploadModal
    | HideFileUploadModal
    | OnFileChosen String
    | ConfirmFileUpload String
    | SubmitCreateQuest
    | SubmitCreateQuestResult (Result Http.Error Quest)
    | UploadQuestImageFinished ( Bool, String )


type alias CreateQuestModel =
    { questName : String
    , questDescription : String
    , questImageUrl : String
    , imageUploadModalOpen : Bool
    , imageUploadModalFor : Maybe String
    , imageUploadPath : Maybe String
    , questImageUploadPending : Bool
    , questImageUploadError : Bool
    , submitPending : Bool
    , submitError : Bool
    , token : Maybe String
    }


createQuestInitialModel =
    { questName = ""
    , questDescription = ""
    , questImageUrl = "/placeholder.png"
    , imageUploadModalOpen = False
    , imageUploadModalFor = Nothing
    , imageUploadPath = Nothing
    , questImageUploadPending = False
    , questImageUploadError = False
    , submitPending = False
    , submitError = False
    , token = Nothing
    }


handleTacoMsg : TacoMsg -> CreateQuestModel -> Taco -> ( CreateQuestModel, Cmd CreateQuestMsg )
handleTacoMsg tacoMsg model taco =
    case tacoMsg of
        CreateQuestRoute ->
            ( createQuestInitialModel, Cmd.none )

        _ ->
            ( model, Cmd.none )


onUpdate : CreateQuestMsg -> TacoMsg -> CreateQuestModel -> Taco -> ( CreateQuestModel, Cmd CreateQuestMsg )
onUpdate msg tacoMsg model taco =
    let
        ( createQuest, commands ) =
            handleTacoMsg tacoMsg model taco
    in
        case msg of
            UploadQuestImageFinished ( success, questImageUrl ) ->
                if success then
                    ( { createQuest
                        | questImageUploadPending = False
                        , questImageUploadError = True
                        , questImageUrl = questImageUrl
                        , imageUploadModalOpen = False
                      }
                    , commands
                    )
                else
                    ( { createQuest
                        | questImageUploadPending = False
                        , questImageUploadError = True
                      }
                    , commands
                    )

            SubmitCreateQuest ->
                ( { createQuest
                    | submitPending = True
                    , submitError = False
                  }
                , Http.send SubmitCreateQuestResult
                    (createQuestRequest
                        taco.flags.apiEndpoint
                        (Maybe.withDefault "" taco.token)
                        { id = ""
                        , name = createQuest.questName
                        , description = createQuest.questDescription
                        , imageUrl = createQuest.questImageUrl
                        }
                    )
                )

            SubmitCreateQuestResult (Result.Ok quest) ->
                ( createQuest
                , Navigation.modifyUrl "/#profile"
                )

            SubmitCreateQuestResult (Result.Err _) ->
                ( { createQuest
                    | submitError = True
                  }
                , commands
                )

            OnFileChosen filePath ->
                ( { createQuest
                    | imageUploadPath = Just filePath
                  }
                , commands
                )

            ShowFileUploadModal ->
                ( { createQuest
                    | imageUploadModalOpen = True
                    , imageUploadPath = Nothing
                  }
                , commands
                )

            HideFileUploadModal ->
                ( { createQuest
                    | imageUploadModalOpen = False
                    , imageUploadPath = Nothing
                  }
                , commands
                )

            ConfirmFileUpload fileInputId ->
                ( { createQuest
                    | questImageUploadPending = True
                    , questImageUploadError = False
                  }
                , uploadQuestImage fileInputId
                )

            EditQuestName questName ->
                ( { createQuest
                    | questName = questName
                  }
                , commands
                )

            EditQuestDescription questDescription ->
                ( { createQuest
                    | questDescription = questDescription
                  }
                , commands
                )

            NoOp ->
                ( createQuest, commands )
