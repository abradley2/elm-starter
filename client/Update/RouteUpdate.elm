module Update.RouteUpdate exposing (parseLocation, routeUpdate, Route, Route(..), route)

import Message exposing (Message(..))
import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = QuestsRoute
    | SideQuestsRoute
    | MyAdventurerRoute
    | CreateQuestRoute
    | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map QuestsRoute (UrlParser.top)
        , map QuestsRoute (UrlParser.s "quests")
        , map SideQuestsRoute (UrlParser.s "sidequests")
        , map MyAdventurerRoute (UrlParser.s "profile")
        , map CreateQuestRoute (UrlParser.s "newquest")
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
