module Update.RouteUpdate exposing (parseLocation, routeUpdate, routeData)

import Msg exposing (Msg(..))
import Navigation exposing (Location)
import UrlParser exposing (..)
import Types exposing (Route, Route(..), RouteData)


matchers : Parser (Route -> a) a
matchers =
    oneOf
        [ map QuestsRoute (UrlParser.top)
        , map QuestsRoute (UrlParser.s "quests")
        , map QuestDetailsRoute (UrlParser.s "details" </> UrlParser.string)
        , map SideQuestsRoute (UrlParser.s "sidequests" </> UrlParser.string)
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


routeUpdate : Msg -> RouteData -> List (Cmd Msg) -> ( RouteData, List (Cmd Msg) )
routeUpdate msg routeData commands =
    case msg of
        OnLocationChange location ->
            ( parseLocation location, commands )

        _ ->
            ( routeData, commands )
