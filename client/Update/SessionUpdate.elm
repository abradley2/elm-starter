module Update.SessionUpdate exposing (tacoUpdate, tacoInitialModel, userIsLoggedIn)

import Navigation exposing (Location)
import Msg exposing (Msg, Msg(..))
import Msg.SessionMsg exposing (SessionMsg, SessionMsg(..))
import Request.SessionRequest exposing (loadSession)
import Types exposing (Taco, Flags, RouteData, Route, Route(..))


tacoInitialModel : Flags -> RouteData -> Taco
tacoInitialModel flags routeData =
    { flags = flags
    , token = Nothing
    , username = Nothing
    , userId = Nothing
    , routeData = routeData
    }


userIsLoggedIn : Taco -> Bool
userIsLoggedIn taco =
    taco.token /= Nothing


onSessionMsg : SessionMsg -> ( RouteData, Taco ) -> List (Cmd Msg) -> ( Taco, List (Cmd Msg) )
onSessionMsg userMsg ( routeData, taco ) commands =
    case userMsg of
        GetTokenResult (Result.Ok token) ->
            ( { taco | token = Just token }, commands )

        GetTokenResult (Result.Err _) ->
            ( { taco
                | token = Nothing
                , username = Nothing
                , userId = Nothing
              }
            , commands
            )

        LoadSessionResult (Result.Ok tacoInfo) ->
            ( { taco
                | username = Just tacoInfo.username
                , userId = Just tacoInfo.userId
              }
            , let
                ( route, location ) =
                    routeData
              in
                (commands
                    {- Refresh the page when we load a taco -} ++
                        [ Navigation.modifyUrl location.hash
                        ]
                )
            )

        LoadSessionResult (Result.Err _) ->
            ( { taco
                | token = Nothing
                , username = Nothing
                , userId = Nothing
              }
            , commands
            )


tacoUpdate : Msg -> ( RouteData, Taco ) -> List (Cmd Msg) -> ( Taco, List (Cmd Msg) )
tacoUpdate msg ( routeData, taco ) commands =
    case msg of
        OnLocationChange location ->
            ( { taco | routeData = routeData }, commands )

        Session tacoMsg ->
            onSessionMsg tacoMsg ( routeData, taco ) commands

        LoadToken token ->
            ( { taco | token = Just token }, commands ++ [ Cmd.map Session (loadSession taco.flags.apiEndpoint token) ] )

        _ ->
            ( taco, commands )
