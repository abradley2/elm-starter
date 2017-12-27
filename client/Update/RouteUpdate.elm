module Update.RouteUpdate exposing (parseLocation, routeUpdate, routeModel, RouteModel, RouteModel(..))

import UrlParser exposing (..)
import Message exposing (Message(..))
import Navigation exposing (Location)
import UrlParser exposing (..)


type RouteModel
    = HomeRoute
    | AboutRoute
    | NotFoundRoute


matchers : Parser (RouteModel -> a) a
matchers =
    oneOf
        [ map HomeRoute (UrlParser.top)
        , map HomeRoute (UrlParser.s "home")
        , map AboutRoute (UrlParser.s "about")
        ]


parseLocation : Location -> List (Cmd Message) -> ( RouteModel, List (Cmd Message) )
parseLocation location commands =
    case (parseHash matchers location) of
        Just route ->
            ( route, commands )

        Nothing ->
            ( NotFoundRoute, commands )


routeModel location commands =
    parseLocation location commands


routeUpdate : Message -> RouteModel -> List (Cmd Message) -> ( RouteModel, List (Cmd Message) )
routeUpdate message routeModel commands =
    case message of
        OnLocationChange location ->
            parseLocation location commands

        _ ->
            ( routeModel, commands )
