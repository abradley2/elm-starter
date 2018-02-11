module Update.RouteUpdate exposing (parseLocation, routeUpdate, Route, Route(..), routeData, RouteData)

import Message exposing (Message(..))
import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
    = QuestsRoute
    | SideQuestsRoute
    | MyAdventurerRoute
    | CreateQuestRoute
    | NotFoundRoute


type alias RouteData =
    ( Route, Location )


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map QuestsRoute (UrlParser.top)
        , map QuestsRoute (UrlParser.s "quests")
        , map SideQuestsRoute (UrlParser.s "sidequests")
        , map MyAdventurerRoute (UrlParser.s "profile")
        , map CreateQuestRoute (UrlParser.s "newquest")
        ]


parseLocation : Location -> RouteData
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            ( route, location )

        Nothing ->
            ( QuestsRoute, location )


routeData location =
    parseLocation location


routeUpdate : Message -> RouteData -> List (Cmd Message) -> ( RouteData, List (Cmd Message) )
routeUpdate message routeData commands =
    case message of
        OnLocationChange location ->
            ( parseLocation location, commands )

        _ ->
            ( routeData, commands )
