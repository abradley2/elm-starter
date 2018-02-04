module Update.SessionUpdate exposing (sessionUpdate, sessionInitialModel, userIsLoggedIn)

import Message exposing (Message, Message(..))
import Message.SessionMessage exposing (SessionMessage, SessionMessage(..))
import Request.SessionRequest exposing (loadSession)
import Update.RouteUpdate exposing (Route, Route(..))
import Types exposing (SessionModel)


sessionInitialModel : SessionModel
sessionInitialModel =
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
            ( { session
                | token = Nothing
                , username = Nothing
                , userId = Nothing
              }
            , commands
            )


sessionUpdate : Message -> ( Route, SessionModel ) -> List (Cmd Message) -> ( SessionModel, List (Cmd Message) )
sessionUpdate message ( route, session ) commands =
    case message of
        Session sessionMessage ->
            onSessionMessage sessionMessage session commands

        LoadToken token ->
            ( { session | token = Just token }, commands ++ [ Cmd.map Session (loadSession token) ] )

        _ ->
            ( session, commands )
