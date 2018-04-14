module Update.QuestDetailsUpdate
    exposing
        ( onUpdate
        , onTacoMsg
        , questDetailsInitialModel
        , QuestDetailsModel
        , QuestDetailsMsg
        , QuestDetailsMsg(..)
        )

import Types exposing (Taco, TacoMsg, TacoMsg(..), SideQuest, RecentPostedQuest, QuestDetailsResponse)
import Request.QuestsRequest exposing (getQuestDetails, decideSideQuest, suggestSideQuest)
import String
import Array
import Http


type QuestDetailsMsg
    = NoOp
    | GetQuestDetailsResult (Result Http.Error QuestDetailsResponse)
    | DecideSideQuestResult (Result Http.Error QuestDetailsResponse)
    | ToggleShowingSuggestedSideQuests Bool
    | AcceptSuggestedSideQuest
    | DeclineSuggestedSideQuest
    | ToggleShowingSideQuestModal (Maybe SideQuest)
    | AcceptSideQuest String
    | DeclineSideQuest String
      -- side quest messages
    | ShowSideQuestForm
    | HideSideQuestForm
    | SubmitSideQuestForm
    | SuggestSideQuestResult (Result Http.Error (List SideQuest))
    | EditSideQuestName String
    | EditSideQuestDescription String


type alias QuestDetailsModel =
    { quest : Maybe RecentPostedQuest
    , sideQuests : Maybe (List SideQuest)
    , suggestedSideQuests : Maybe (List SideQuest)
    , showingSuggestedSideQuests : Bool
    , decidingSideQuest : Maybe SideQuest
    , questFormOpen : Bool
    , sideQuestName : String
    , sideQuestDescription : String
    , suggestingSideQuest : Bool
    , suggestSideQuestSuccess : Maybe Bool
    }


questDetailsInitialModel : QuestDetailsModel
questDetailsInitialModel =
    { quest = Nothing
    , sideQuests = Nothing
    , suggestedSideQuests = Nothing
    , showingSuggestedSideQuests = False
    , decidingSideQuest = Nothing
    , questFormOpen = False
    , sideQuestName = ""
    , sideQuestDescription = ""
    , suggestingSideQuest = False
    , suggestSideQuestSuccess = Nothing
    }


isOwnQuest : Taco -> QuestDetailsModel -> Bool
isOwnQuest taco model =
    let
        ( questUserId, userId ) =
            Maybe.withDefault ( "foo", "bar" )
                (Maybe.map2
                    (\quest userId -> ( quest.userId, userId ))
                    model.quest
                    taco.userId
                )
    in
        questUserId == userId


decideOnSuggestedSideQuest : Taco -> QuestDetailsModel -> Bool -> Cmd QuestDetailsMsg
decideOnSuggestedSideQuest taco model isAccepted =
    let
        request =
            Maybe.map2
                (\quest sideQuest ->
                    Http.send DecideSideQuestResult
                        (decideSideQuest
                            { apiEndpoint = taco.flags.apiEndpoint
                            , isAccepted = isAccepted
                            , sideQuestId = sideQuest.id
                            , questId = quest.id
                            }
                        )
                )
                model.quest
                model.decidingSideQuest
    in
        Maybe.withDefault Cmd.none request


onTacoMsg : TacoMsg -> ( QuestDetailsModel, Taco ) -> ( QuestDetailsModel, Cmd QuestDetailsMsg )
onTacoMsg tacoMsg ( model, taco ) =
    case tacoMsg of
        QuestDetailsRoute params ->
            let
                paramArray =
                    Array.fromList (String.split ":" params)

                request =
                    Maybe.map2
                        (\userId questId ->
                            Http.send GetQuestDetailsResult
                                (getQuestDetails
                                    taco.flags.apiEndpoint
                                    userId
                                    questId
                                )
                        )
                        (Array.get 0 paramArray)
                        (Array.get 1 paramArray)
            in
                ( questDetailsInitialModel, Maybe.withDefault Cmd.none request )

        _ ->
            ( model, Cmd.none )


onUpdate : QuestDetailsMsg -> ( QuestDetailsModel, Taco ) -> ( QuestDetailsModel, Cmd QuestDetailsMsg )
onUpdate msg ( model, taco ) =
    case msg of
        DecideSideQuestResult (Result.Ok response) ->
            ( { model
                | quest = Just response.quest
                , sideQuests = Just response.sideQuests
                , suggestedSideQuests = Just response.suggestedSideQuests
              }
            , Cmd.none
            )

        DecideSideQuestResult (Result.Err _) ->
            ( model, Cmd.none )

        GetQuestDetailsResult (Result.Ok response) ->
            ( { model
                | quest = Just response.quest
                , sideQuests = Just response.sideQuests
                , suggestedSideQuests = Just response.suggestedSideQuests
              }
            , Cmd.none
            )

        GetQuestDetailsResult (Result.Err _) ->
            ( model, Cmd.none )

        ToggleShowingSuggestedSideQuests isShowing ->
            ( { model
                | showingSuggestedSideQuests = isShowing
                , questFormOpen = False
              }
            , Cmd.none
            )

        AcceptSuggestedSideQuest ->
            ( { model
                | decidingSideQuest = Nothing
                , quest = Nothing
                , sideQuests = Nothing
                , suggestedSideQuests = Nothing
              }
            , decideOnSuggestedSideQuest taco model True
            )

        DeclineSuggestedSideQuest ->
            ( { model
                | decidingSideQuest = Nothing
                , quest = Nothing
                , sideQuests = Nothing
                , suggestedSideQuests = Nothing
              }
            , decideOnSuggestedSideQuest taco model False
            )

        ToggleShowingSideQuestModal ifSideQuest ->
            ( { model | decidingSideQuest = ifSideQuest }, Cmd.none )

        AcceptSideQuest sideQuestId ->
            ( model, Cmd.none )

        DeclineSideQuest sideQuestId ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )

        SuggestSideQuestResult (Result.Err _) ->
            ( { model
                | suggestingSideQuest = False
                , suggestSideQuestSuccess = Just False
              }
            , Cmd.none
            )

        SuggestSideQuestResult (Result.Ok sideQuests) ->
            let
                updatedModel =
                    if Debug.log "is own quest " (isOwnQuest taco model) then
                        { model | sideQuests = Just sideQuests }
                    else
                        { model | suggestedSideQuests = Just sideQuests }
            in
                ( { updatedModel
                    | suggestingSideQuest = False
                    , suggestSideQuestSuccess = Just True
                  }
                , Cmd.none
                )

        ShowSideQuestForm ->
            ( { model
                | questFormOpen = True
                , sideQuestName = ""
                , sideQuestDescription = ""
                , showingSuggestedSideQuests = False
              }
            , Cmd.none
            )

        HideSideQuestForm ->
            ( { model | questFormOpen = False }, Cmd.none )

        SubmitSideQuestForm ->
            ( { model
                | questFormOpen = False
                , suggestingSideQuest = True
              }
            , Maybe.withDefault Cmd.none
                (Maybe.map
                    (\quest ->
                        Http.send SuggestSideQuestResult
                            (suggestSideQuest
                                taco.flags.apiEndpoint
                                quest
                                { guid = ""
                                , name = model.sideQuestName
                                , description = model.sideQuestDescription
                                , suggestedBy = ""
                                , id = ""
                                }
                            )
                    )
                    model.quest
                )
            )

        EditSideQuestName newName ->
            ( { model | sideQuestName = newName }, Cmd.none )

        EditSideQuestDescription newDescription ->
            ( { model | sideQuestDescription = newDescription }, Cmd.none )
