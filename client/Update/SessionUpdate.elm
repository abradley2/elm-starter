module Update.SessionUpdate exposing (sessionUpdate, sessionInitialModel, userIsLoggedIn)

import Navigation exposing (Location)
import Msg exposing (Msg, Msg(..))
import Msg.SessionMsg exposing (SessionMsg, SessionMsg(..))
import Request.SessionRequest exposing (loadSession)
import Types exposing (SessionModel, Flags, RouteData, Route, Route(..))


sessionInitialModel : Flags -> RouteData -> SessionModel
sessionInitialModel flags routeData =
    { flags = flags
    , token = Nothing
    , username = Nothing
    , userId = Nothing
    , routeData = routeData
    }


userIsLoggedIn : SessionModel -> Bool
userIsLoggedIn session =
    session.token /= Nothing


onSessionMsg : SessionMsg -> ( RouteData, SessionModel ) -> List (Cmd Msg) -> ( SessionModel, List (Cmd Msg) )
onSessionMsg userMsg ( routeData, session ) commands =
    case userMsg of
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


sessionUpdate : Msg -> ( RouteData, SessionModel ) -> List (Cmd Msg) -> ( SessionModel, List (Cmd Msg) )
sessionUpdate msg ( routeData, session ) commands =
    case msg of
        OnLocationChange location ->
            ( { session | routeData = routeData }, commands )

        Session sessionMsg ->
            onSessionMsg sessionMsg ( routeData, session ) commands

        LoadToken token ->
            ( { session | token = Just token }, commands ++ [ Cmd.map Session (loadSession session.flags.apiEndpoint token) ] )

        _ ->
            ( session, commands )
