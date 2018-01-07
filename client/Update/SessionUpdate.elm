module Update.SessionUpdate exposing (SessionModel, sessionUpdate, sessionModel)

import Message exposing (Message, Message(..))
import Message.SessionMessage exposing (SessionMessage, SessionMessage(..))
import Update.RouteUpdate exposing (parseLocation, Route, Route(..))
import Request.QuestsRequest exposing (getQuests)


type alias SessionModel =
    { token : Maybe String
    }


sessionModel : SessionModel
sessionModel =
    { token = Maybe.Nothing
    }


onSessionMessage : SessionMessage -> SessionModel -> List (Cmd Message) -> ( SessionModel, List (Cmd Message) )
onSessionMessage userMessage sessionModel commands =
    case userMessage of
        GetTokenResult (Result.Ok token) ->
            ( { sessionModel | token = Maybe.Just token }, commands )

        GetTokenResult (Result.Err _) ->
            ( sessionModel, commands )


onRouteChange : Route -> SessionModel -> List (Cmd Message) -> ( SessionModel, List (Cmd Message) )
onRouteChange newRoute session commands =
    case newRoute of
        QuestsRoute ->
            let
                token =
                    Maybe.withDefault "" session.token
            in
                ( session
                , commands ++ [ Cmd.map Quests (getQuests token) ]
                )

        _ ->
            ( sessionModel, commands )


sessionUpdate : Message -> SessionModel -> List (Cmd Message) -> ( SessionModel, List (Cmd Message) )
sessionUpdate message session commands =
    case message of
        Session sessionMessage ->
            onSessionMessage sessionMessage session commands

        OnLocationChange location ->
            onRouteChange (parseLocation location) session commands

        _ ->
            ( session, commands )
