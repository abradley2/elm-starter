module Update.CreateQuestUpdate
    exposing
        ( createQuestUpdate
        , createQuestInitialModel
        , CreateQuestModel
        )

import Navigation
import Html.Attributes exposing (name)
import Msg exposing (Msg, Msg(..))
import Msg.CreateQuestMsg exposing (CreateQuestMsg, CreateQuestMsg(..))
import Request.CreateQuestRequest exposing (createQuestRequest)
import Update.RouteUpdate exposing (parseLocation)
import Ports exposing (requestQuestStepId, requestQuestId, uploadQuestImage)
import Types exposing (SessionModel, Route(..))
import Array


type alias CreateQuestModel =
    { id : String
    , questName : String
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
    { id = ""
    , questName = ""
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


onMountCreateQuestView : CreateQuestModel -> List (Cmd Msg) -> ( CreateQuestModel, List (Cmd Msg) )
onMountCreateQuestView createQuest commands =
    ( ({ createQuestInitialModel | token = createQuest.token })
    , commands ++ [ requestQuestId "gimme!" ]
    )


onCreateQuestMsg : CreateQuestMsg -> ( SessionModel, CreateQuestModel ) -> List (Cmd Msg) -> ( CreateQuestModel, List (Cmd Msg) )
onCreateQuestMsg createQuestMsg ( session, createQuest ) commands =
    case createQuestMsg of
        SubmitCreateQuest ->
            ( { createQuest
                | submitPending = True
                , submitError = False
              }
            , (commands
                ++ [ Cmd.map CreateQuest
                        (createQuestRequest
                            session.flags.apiEndpoint
                            (Maybe.withDefault "" session.token)
                            { id = createQuest.id
                            , name = createQuest.questName
                            , description = createQuest.questDescription
                            , imageUrl = createQuest.questImageUrl
                            }
                        )
                   ]
              )
            )

        SubmitCreateQuestResult (Result.Ok quest) ->
            ( createQuest
            , (commands
                ++ [ Navigation.modifyUrl "/#profile" ]
              )
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

        ShowFileUploadModal id ->
            ( { createQuest
                | imageUploadModalOpen = True
                , imageUploadPath = Nothing
                , imageUploadModalFor = Just id
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

        ConfirmFileUpload id ->
            ( { createQuest
                | questImageUploadPending = True
                , questImageUploadError = False
              }
            , commands ++ [ uploadQuestImage ("fileinput-" ++ id) ]
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

        _ ->
            ( createQuest, commands )


createQuestUpdate : Msg -> ( SessionModel, CreateQuestModel ) -> List (Cmd Msg) -> ( CreateQuestModel, List (Cmd Msg) )
createQuestUpdate msg ( session, createQuest ) commands =
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

        CreateQuest createQuestMsg ->
            onCreateQuestMsg createQuestMsg ( session, createQuest ) commands

        LoadQuestId cuid ->
            ( { createQuest | id = cuid }, commands )

        OnLocationChange location ->
            let
                ( route, locationData ) =
                    parseLocation location
            in
                case route of
                    CreateQuestRoute ->
                        onMountCreateQuestView createQuest commands

                    _ ->
                        ( createQuest, commands )

        _ ->
            ( createQuest, commands )
