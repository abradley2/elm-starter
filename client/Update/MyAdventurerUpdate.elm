module Update.MyAdventurerUpdate
    exposing
        ( myAdventurerUpdate
        , myAdventurerInitialModel
        , MyAdventurerModel
        )

import Msg exposing (Msg, Msg(..))
import Msg.MyAdventurerMsg exposing (MyAdventurerMsg, MyAdventurerMsg(..))
import Update.RouteUpdate exposing (parseLocation)
import Request.QuestsRequest exposing (getQuestsByUser)
import Types exposing (SessionModel, RecentPostedQuest, RouteData, Route, Route(..))


type alias MyAdventurerModel =
    { quests : List RecentPostedQuest
    }


myAdventurerInitialModel =
    { quests = []
    }


fetchQuests apiEndpoint token userId =
    Cmd.map MyAdventurer
        (getQuestsByUser apiEndpoint token userId)


onRouteChange : RouteData -> ( SessionModel, MyAdventurerModel ) -> List (Cmd Msg) -> ( MyAdventurerModel, List (Cmd Msg) )
onRouteChange routeData ( session, myAdventurer ) commands =
    let
        ( route, location ) =
            routeData
    in
        case route of
            MyAdventurerRoute ->
                case session.userId of
                    Just userId ->
                        ( myAdventurer
                        , commands
                            ++ [ fetchQuests session.flags.apiEndpoint (Maybe.withDefault "" session.token) userId
                               ]
                        )

                    Nothing ->
                        ( myAdventurer, commands )

            _ ->
                ( myAdventurer, commands )


onMyAdventurerMsg : MyAdventurerMsg -> MyAdventurerModel -> List (Cmd Msg) -> ( MyAdventurerModel, List (Cmd Msg) )
onMyAdventurerMsg myAdventurerMsg myAdventurer commands =
    case myAdventurerMsg of
        GetQuestsByUserResult (Result.Ok quests) ->
            ( { myAdventurer | quests = quests }, commands )

        GetQuestsByUserResult (Result.Err _) ->
            ( myAdventurer, commands )

        NoOp ->
            ( myAdventurer, commands )


myAdventurerUpdate : Msg -> ( SessionModel, MyAdventurerModel ) -> List (Cmd Msg) -> ( MyAdventurerModel, List (Cmd Msg) )
myAdventurerUpdate msg ( session, myAdventurer ) commands =
    case msg of
        OnLocationChange location ->
            onRouteChange (parseLocation location) ( session, myAdventurer ) commands

        MyAdventurer myAdventurerMsg ->
            onMyAdventurerMsg myAdventurerMsg myAdventurer commands

        _ ->
            ( myAdventurer, commands )
