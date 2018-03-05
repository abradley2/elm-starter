module Update.QuestDetailsUpdate exposing (QuestDetailsModel, questDetailsUpdate, questDetailsInitialModel)

import Message exposing (Message, Message(..))
import Message.QuestDetailsMessage exposing (QuestDetailsMessage, QuestDetailsMessage(..))
import UrlParser exposing (..)
import Types exposing (SessionModel, Route, Route(..), SideQuest, RecentPostedQuest)
import Request.QuestsRequest exposing (getQuestDetails)
import String
import Array


type alias QuestDetailsModel =
    { quest : Maybe RecentPostedQuest
    , sideQuests : Maybe (List SideQuest)
    , suggestedSideQuests : Maybe (List SideQuest)
    }


questDetailsInitialModel : QuestDetailsModel
questDetailsInitialModel =
    { quest = Nothing
    , sideQuests = Nothing
    , suggestedSideQuests = Nothing
    }


onQuestDetailsMessage : QuestDetailsMessage -> ( SessionModel, QuestDetailsModel ) -> List (Cmd Message) -> ( QuestDetailsModel, List (Cmd Message) )
onQuestDetailsMessage message ( session, questDetails ) commands =
    case message of
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

        NoOp ->
            ( questDetails, commands )


questDetailsUpdate : Message -> ( SessionModel, QuestDetailsModel ) -> List (Cmd Message) -> ( QuestDetailsModel, List (Cmd Message) )
questDetailsUpdate message ( session, questDetails ) commands =
    case message of
        QuestDetails questDetailsMessage ->
            onQuestDetailsMessage questDetailsMessage ( session, questDetails ) commands

        OnLocationChange newLocation ->
            let
                ( route, location ) =
                    session.routeData
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
                                                session.flags.apiEndpoint
                                                userId
                                                questId
                                            )
                                        ]
                                    )
                                    (Array.get 0 paramArray)
                                    (Array.get 1 paramArray)
                        in
                            ( questDetails, commands ++ (Maybe.withDefault [] request) )

                    _ ->
                        ( questDetails, commands )

        _ ->
            ( questDetails, commands )
