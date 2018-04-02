module Update.QuestDetailsUpdate
    exposing
        ( onUpdate
        , onTacoMsg
        , questDetailsInitialModel
        , QuestDetailsModel
        , QuestDetailsMsg
        , QuestDetailsMsg(..)
        )

import UrlParser exposing (..)
import Types exposing (Taco, TacoMsg, TacoMsg(..), SideQuest, RecentPostedQuest, QuestDetailsResponse)
import Request.QuestsRequest exposing (getQuestDetails, decideSideQuest)
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


type alias QuestDetailsModel =
    { quest : Maybe RecentPostedQuest
    , sideQuests : Maybe (List SideQuest)
    , suggestedSideQuests : Maybe (List SideQuest)
    , showingSuggestedSideQuests : Bool
    , decidingSideQuest : Maybe SideQuest
    }


questDetailsInitialModel : QuestDetailsModel
questDetailsInitialModel =
    { quest = Nothing
    , sideQuests = Nothing
    , suggestedSideQuests = Nothing
    , showingSuggestedSideQuests = False
    , decidingSideQuest = Nothing
    }


decideOnSuggestedSideQuest : Taco -> QuestDetailsModel -> Bool -> Cmd QuestDetailsMsg
decideOnSuggestedSideQuest taco model isAccepted =
    let
        request =
            Maybe.map3
                (\userToken quest sideQuest ->
                    Http.send DecideSideQuestResult
                        (decideSideQuest
                            { apiEndpoint = taco.flags.apiEndpoint
                            , userToken = userToken
                            , isAccepted = isAccepted
                            , sideQuestId = sideQuest.id
                            , questId = quest.id
                            }
                        )
                )
                taco.token
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
