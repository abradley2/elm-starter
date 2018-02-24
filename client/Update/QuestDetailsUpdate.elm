module Update.QuestDetailsUpdate exposing (QuestDetailsModel, questDetailsUpdate, questDetailsInitialModel)

import Message exposing (Message, Message(..))
import Message.QuestDetailsMessage exposing (QuestDetailsMessage, QuestDetailsMessage(..))
import UrlParser exposing (..)
import Types exposing (SessionModel, Route, Route(..))
import Request.QuestsRequest exposing (getQuestDetails)


type alias QuestDetailsModel =
    {}


questDetailsInitialModel : QuestDetailsModel
questDetailsInitialModel =
    {}


onQuestDetailsMessage : QuestDetailsMessage -> ( SessionModel, QuestDetailsModel ) -> List (Cmd Message) -> ( QuestDetailsModel, List (Cmd Message) )
onQuestDetailsMessage message ( session, questDetails ) commands =
    case message of
        GetQuestDetailsResult (Result.Ok response) ->
            ( questDetails, commands )

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
                        ( questDetails, commands )

                    _ ->
                        ( questDetails, commands )

        _ ->
            ( questDetails, commands )
