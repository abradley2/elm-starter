module Update.SessionUpdate exposing (sessionUpdate, sessionInitialModel, userIsLoggedIn)

import Navigation
import Message exposing (Message, Message(..))
import Message.SessionMessage exposing (SessionMessage, SessionMessage(..))
import Request.SessionRequest exposing (loadSession)
import Update.RouteUpdate exposing (RouteData, Route, Route(..))
import Types exposing (SessionModel, Flags)


sessionInitialModel : Flags -> SessionModel
sessionInitialModel flags =
    { flags = flags
    , token = Nothing
    , username = Nothing
    , userId = Nothing
    }


userIsLoggedIn : SessionModel -> Bool
userIsLoggedIn session =
    session.token /= Nothing


onSessionMessage : SessionMessage -> ( RouteData, SessionModel ) -> List (Cmd Message) -> ( SessionModel, List (Cmd Message) )
onSessionMessage userMessage ( routeData, session ) commands =
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
            , let
                ( route, location ) =
                    routeData
              in
                (commands
                    {- Refresh the page when we load a session -} ++
                        [ Navigation.modifyUrl location.hash
                        ]
                )
            )

        LoadSessionResult (Result.Err _) ->
            ( { session
                | token = Nothing
                , username = Nothing
                , userId = Nothing
              }
            , commands
            )


sessionUpdate : Message -> ( RouteData, SessionModel ) -> List (Cmd Message) -> ( SessionModel, List (Cmd Message) )
sessionUpdate message ( routeData, session ) commands =
    case message of
        Session sessionMessage ->
            onSessionMessage sessionMessage ( routeData, session ) commands

        LoadToken token ->
            ( { session | token = Just token }, commands ++ [ Cmd.map Session (loadSession session.flags.apiEndpoint token) ] )

        _ ->
            ( session, commands )
