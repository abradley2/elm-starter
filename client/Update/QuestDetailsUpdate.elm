module Update.QuestDetailsUpdate exposing (QuestDetailsModel, questDetailsUpdate, questDetailsInitialModel)

import Msg exposing (Msg, Msg(..))
import Msg.QuestDetailsMsg exposing (QuestDetailsMsg, QuestDetailsMsg(..))
import UrlParser exposing (..)
import Types exposing (Taco, Route, Route(..), SideQuest, RecentPostedQuest)
import Request.QuestsRequest exposing (getQuestDetails, decideSideQuest)
import String
import Array


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


decideOnSuggestedSideQuest : Taco -> QuestDetailsModel -> Bool -> Cmd Msg
decideOnSuggestedSideQuest taco questDetails isAccepted =
    let
        isCmd =
            Maybe.map3
                (\userToken quest sideQuest ->
                    decideSideQuest
                        { apiEndpoint = taco.flags.apiEndpoint
                        , userToken = userToken
                        , isAccepted = isAccepted
                        , sideQuestId = sideQuest.id
                        , questId = quest.id
                        }
                )
                taco.token
                questDetails.quest
                questDetails.decidingSideQuest
    in
        case isCmd of
            Just cmd ->
                Cmd.map QuestDetails cmd

            Nothing ->
                Cmd.none


onQuestDetailsMsg : QuestDetailsMsg -> ( Taco, QuestDetailsModel ) -> List (Cmd Msg) -> ( QuestDetailsModel, List (Cmd Msg) )
onQuestDetailsMsg msg ( taco, questDetails ) commands =
    case msg of
        DecideSideQuestResult (Result.Ok response) ->
            ( { questDetails
                | quest = Just response.quest
                , sideQuests = Just response.sideQuests
                , suggestedSideQuests = Just response.suggestedSideQuests
              }
            , commands
            )

        DecideSideQuestResult (Result.Err _) ->
            ( questDetails, commands )

        GetQuestDetailsResult (Result.Ok response) ->
            ( { questDetails
                | quest = Just response.quest
                , sideQuests = Just response.sideQuests
                , suggestedSideQuests = Just response.suggestedSideQuests
              }
            , commands
            )

        GetQuestDetailsResult (Result.Err _) ->
            ( questDetails, commands )

        ToggleShowingSuggestedSideQuests isShowing ->
            ( { questDetails
                | showingSuggestedSideQuests = isShowing
              }
            , commands
            )

        AcceptSuggestedSideQuest ->
            ( { questDetails
                | decidingSideQuest = Nothing
                , quest = Nothing
                , sideQuests = Nothing
                , suggestedSideQuests = Nothing
              }
            , commands ++ [ decideOnSuggestedSideQuest taco questDetails True ]
            )

        DeclineSuggestedSideQuest ->
            ( { questDetails
                | decidingSideQuest = Nothing
                , quest = Nothing
                , sideQuests = Nothing
                , suggestedSideQuests = Nothing
              }
            , commands ++ [ decideOnSuggestedSideQuest taco questDetails False ]
            )

        ToggleShowingSideQuestModal ifSideQuest ->
            ( { questDetails | decidingSideQuest = ifSideQuest }, commands )

        AcceptSideQuest sideQuestId ->
            ( questDetails, commands )

        DeclineSideQuest sideQuestId ->
            ( questDetails, commands )

        NoOp ->
            ( questDetails, commands )


questDetailsUpdate : Msg -> ( Taco, QuestDetailsModel ) -> List (Cmd Msg) -> ( QuestDetailsModel, List (Cmd Msg) )
questDetailsUpdate msg ( taco, questDetails ) commands =
    case msg of
        QuestDetails questDetailsMsg ->
            onQuestDetailsMsg questDetailsMsg ( taco, questDetails ) commands

        OnLocationChange newLocation ->
            let
                ( route, location ) =
                    taco.routeData
            in
                case route of
                    QuestDetailsRoute params ->
                        let
                            paramArray =
                                Array.fromList (String.split ":" params)

                            request =
                                Maybe.map2
                                    (\userId questId ->
                                        [ Cmd.map QuestDetails
                                            (getQuestDetails
                                                taco.flags.apiEndpoint
                                                userId
                                                questId
                                            )
                                        ]
                                    )
                                    (Array.get 0 paramArray)
                                    (Array.get 1 paramArray)
                        in
                            ( questDetailsInitialModel, commands ++ (Maybe.withDefault [] request) )

                    _ ->
                        ( questDetails, commands )

        _ ->
            ( questDetails, commands )
