module Update.SessionUpdate exposing (SessionModel, sessionUpdate, sessionModel, userIsLoggedIn)

import Message exposing (Message, Message(..))
import Message.SessionMessage exposing (SessionMessage, SessionMessage(..))
import Update.RouteUpdate exposing (parseLocation, Route, Route(..))
import Request.QuestsRequest exposing (getQuests)
import Request.SessionRequest exposing (loadSession)


type alias SessionModel =
    { token : Maybe String
    , username : Maybe String
    , userId : Maybe String
    }


sessionModel : SessionModel
sessionModel =
    { token = Nothing
    , username = Nothing
    , userId = Nothing
    }


userIsLoggedIn : SessionModel -> Bool
userIsLoggedIn session =
    session.token /= Nothing


onSessionMessage : SessionMessage -> SessionModel -> List (Cmd Message) -> ( SessionModel, List (Cmd Message) )
onSessionMessage userMessage session commands =
    case userMessage of
        GetTokenResult (Result.Ok token) ->
            ( { session | token = Just token }, commands )

        GetTokenResult (Result.Err _) ->
            ( { session
                | token = Nothing
                , username = Nothing
                , userId = Nothing
              }
            , commands
            )

        LoadSessionResult (Result.Ok sessionInfo) ->
            ( { session
                | username = Just sessionInfo.username
                , userId = Just sessionInfo.userId
              }
            , commands
            )

        LoadSessionResult (Result.Err _) ->
            ( session, commands )


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
            ( session, commands )


sessionUpdate : Message -> SessionModel -> List (Cmd Message) -> ( SessionModel, List (Cmd Message) )
sessionUpdate message session commands =
    case message of
        Session sessionMessage ->
            onSessionMessage sessionMessage session commands

        LoadToken token ->
            ( { session | token = Just token }, commands ++ [ Cmd.map Session (loadSession token) ] )

        OnLocationChange location ->
            onRouteChange (parseLocation location) session commands

        _ ->
            ( session, commands )
