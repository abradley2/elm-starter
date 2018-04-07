module Update.CreateQuestUpdate
    exposing
        ( onUpdate
        , onTacoMsg
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
    }


onTacoMsg : TacoMsg -> ( CreateQuestModel, Taco ) -> ( CreateQuestModel, Cmd CreateQuestMsg )
onTacoMsg tacoMsg ( model, taco ) =
    case tacoMsg of
        CreateQuestRoute ->
            ( createQuestInitialModel, Cmd.none )

        _ ->
            ( model, Cmd.none )


onUpdate : CreateQuestMsg -> ( CreateQuestModel, Taco ) -> ( CreateQuestModel, Cmd CreateQuestMsg )
onUpdate msg ( model, taco ) =
    case msg of
        UploadQuestImageFinished ( success, questImageUrl ) ->
            if success then
                ( { model
                    | questImageUploadPending = False
                    , questImageUploadError = False
                    , questImageUrl = questImageUrl
                    , imageUploadModalOpen = False
                  }
                , Cmd.none
                )
            else
                ( { model
                    | questImageUploadPending = False
                    , questImageUploadError = True
                  }
                , Cmd.none
                )

        SubmitCreateQuest ->
            ( { model
                | submitPending = True
                , submitError = False
              }
            , Http.send SubmitCreateQuestResult
                (createQuestRequest
                    taco.flags.apiEndpoint
                    { id = ""
                    , name = model.questName
                    , description = model.questDescription
                    , imageUrl = model.questImageUrl
                    }
                )
            )

        SubmitCreateQuestResult (Result.Ok quest) ->
            ( model
            , Navigation.modifyUrl "/profile"
            )

        SubmitCreateQuestResult (Result.Err _) ->
            ( { model
                | submitError = True
              }
            , Cmd.none
            )

        OnFileChosen filePath ->
            ( { model
                | imageUploadPath = Just filePath
              }
            , Cmd.none
            )

        ShowFileUploadModal ->
            ( { model
                | imageUploadModalOpen = True
                , imageUploadPath = Nothing
              }
            , Cmd.none
            )

        HideFileUploadModal ->
            ( { model
                | imageUploadModalOpen = False
                , imageUploadPath = Nothing
              }
            , Cmd.none
            )

        ConfirmFileUpload fileInputId ->
            ( { model
                | questImageUploadPending = True
                , questImageUploadError = False
              }
            , uploadQuestImage fileInputId
            )

        EditQuestName questName ->
            ( { model
                | questName = questName
              }
            , Cmd.none
            )

        EditQuestDescription questDescription ->
            ( { model
                | questDescription = questDescription
              }
            , Cmd.none
            )

        NoOp ->
            ( model, Cmd.none )
