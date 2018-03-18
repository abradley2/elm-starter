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
import Ports exposing (uploadQuestImage)
import Types exposing (Taco, Route(..))
import Array


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


onCreateQuestMsg : CreateQuestMsg -> ( Taco, CreateQuestModel ) -> List (Cmd Msg) -> ( CreateQuestModel, List (Cmd Msg) )
onCreateQuestMsg createQuestMsg ( taco, createQuest ) commands =
    case createQuestMsg of
        SubmitCreateQuest ->
            ( { createQuest
                | submitPending = True
                , submitError = False
              }
            , (commands
                ++ [ Cmd.map CreateQuest
                        (createQuestRequest
                            taco.flags.apiEndpoint
                            (Maybe.withDefault "" taco.token)
                            { id = ""
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
            , commands ++ [ uploadQuestImage fileInputId ]
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


createQuestUpdate : Msg -> ( Taco, CreateQuestModel ) -> List (Cmd Msg) -> ( CreateQuestModel, List (Cmd Msg) )
createQuestUpdate msg ( taco, createQuest ) commands =
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
            onCreateQuestMsg createQuestMsg ( taco, createQuest ) commands

        OnLocationChange location ->
            let
                ( route, locationData ) =
                    parseLocation location
            in
                case route of
                    CreateQuestRoute ->
                        ( createQuestInitialModel, commands )

                    _ ->
                        ( createQuest, commands )

        _ ->
            ( createQuest, commands )
