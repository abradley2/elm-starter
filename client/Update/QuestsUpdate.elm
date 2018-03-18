module Update.QuestsUpdate exposing (questsModel, questsUpdate, QuestsModel)

import Msg exposing (Msg, Msg(..))
import Msg.QuestsMsg exposing (QuestsMsg, QuestsMsg(..))
import Update.RouteUpdate exposing (parseLocation)
import Request.QuestsRequest exposing (getQuests)
import Types exposing (Taco, RecentPostedQuest, RouteData, Route, Route(..))


type alias QuestsModel =
    { questList : List RecentPostedQuest
    }


questsModel : QuestsModel
questsModel =
    { questList = []
    }


onRouteChange : RouteData -> ( Taco, QuestsModel ) -> List (Cmd Msg) -> ( QuestsModel, List (Cmd Msg) )
onRouteChange routeData ( taco, quests ) commands =
    let
        ( route, location ) =
            routeData
    in
        case route of
            QuestsRoute ->
                let
                    token =
                        Maybe.withDefault "" taco.token
                in
                    ( quests
                    , commands ++ [ Cmd.map Quests (getQuests taco.flags.apiEndpoint token) ]
                    )

            _ ->
                ( quests, commands )


onQuestsMsg : QuestsMsg -> QuestsModel -> List (Cmd Msg) -> ( QuestsModel, List (Cmd Msg) )
onQuestsMsg questsMsg quests commands =
    case questsMsg of
        GetQuestsResult (Result.Ok questList) ->
            ( { quests | questList = questList }, commands )

        GetQuestsResult (Result.Err _) ->
            ( quests, commands )

        NoOp ->
            ( quests, commands )


questsUpdate : Msg -> ( Taco, QuestsModel ) -> List (Cmd Msg) -> ( QuestsModel, List (Cmd Msg) )
questsUpdate msg ( taco, quests ) commands =
    case msg of
        OnLocationChange location ->
            onRouteChange (parseLocation location) ( taco, quests ) commands

        Quests questsMsg ->
            onQuestsMsg questsMsg quests commands

        _ ->
            ( quests, commands )
