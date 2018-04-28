module Page.CreateQuest.Update exposing (..)

import Array
import Http
import Navigation
import Types exposing (Taco, TacoMsg, TacoMsg(..), Quest)
import Request.CreateQuestRequest exposing (createQuestRequest)
import Ports exposing (uploadQuestImage)


type Msg
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


type alias Model =
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


initialModel : Model
initialModel =
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


onTacoMsg : TacoMsg -> ( Model, Taco ) -> ( Model, Cmd Msg )
onTacoMsg tacoMsg ( model, taco ) =
    case tacoMsg of
        CreateQuestRoute ->
            ( initialModel, Cmd.none )

        _ ->
            ( model, Cmd.none )


onMsg : Msg -> ( Model, Taco ) -> ( Model, Cmd Msg )
onMsg msg ( model, taco ) =
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
