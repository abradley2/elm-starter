module Update.QuestsUpdate exposing (questsModel, questsUpdate, QuestsModel)

import Message exposing (Message, Message(..))
import Message.QuestsMessage exposing (QuestsMessage, QuestsMessage(..))
import Update.RouteUpdate exposing (parseLocation)
import Request.QuestsRequest exposing (getQuests)
import Types exposing (SessionModel, RecentPostedQuest, RouteData, Route, Route(..))


type alias QuestsModel =
    { questList : List RecentPostedQuest
    }


questsModel : QuestsModel
questsModel =
    { questList = []
    }


onRouteChange : RouteData -> ( SessionModel, QuestsModel ) -> List (Cmd Message) -> ( QuestsModel, List (Cmd Message) )
onRouteChange routeData ( session, quests ) commands =
    let
        ( route, location ) =
            routeData
    in
        case route of
            QuestsRoute ->
                let
                    token =
                        Maybe.withDefault "" session.token
                in
                    ( quests
                    , commands ++ [ Cmd.map Quests (getQuests session.flags.apiEndpoint token) ]
                    )

            _ ->
                ( quests, commands )


onQuestsMessage : QuestsMessage -> QuestsModel -> List (Cmd Message) -> ( QuestsModel, List (Cmd Message) )
onQuestsMessage questsMessage quests commands =
    case questsMessage of
        GetQuestsResult (Result.Ok questList) ->
            ( { quests | questList = questList }, commands )

        GetQuestsResult (Result.Err _) ->
            ( quests, commands )

        NoOp ->
            ( quests, commands )


questsUpdate : Message -> ( SessionModel, QuestsModel ) -> List (Cmd Message) -> ( QuestsModel, List (Cmd Message) )
questsUpdate message ( session, quests ) commands =
    case message of
        OnLocationChange location ->
            onRouteChange (parseLocation location) ( session, quests ) commands

        Quests questsMessage ->
            onQuestsMessage questsMessage quests commands

        _ ->
            ( quests, commands )
