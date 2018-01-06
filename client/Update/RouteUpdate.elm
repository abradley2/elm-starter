module Update.RouteUpdate exposing (parseLocation, routeUpdate, Route, Route(..), route)

import Message exposing (Message(..))
import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = ArmiesRoute
    | UnitsRoute
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map ArmiesRoute (UrlParser.top)
        , map ArmiesRoute (UrlParser.s "armies")
        , map UnitsRoute (UrlParser.s "units")
        ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute


route location =
    parseLocation location


routeUpdate : Message -> Route -> List (Cmd Message) -> ( Route, List (Cmd Message) )
routeUpdate message routeModel commands =
    case message of
        OnLocationChange location ->
            ( parseLocation location, commands )

        _ ->
            ( routeModel, commands )
