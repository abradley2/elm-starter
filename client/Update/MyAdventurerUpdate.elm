module Update.MyAdventurerUpdate
    exposing
        ( myAdventurerUpdate
        , myAdventurerInitialModel
        , MyAdventurerModel
        )

import Message exposing (Message, Message(..))
import Message.MyAdventurerMessage exposing (MyAdventurerMessage, MyAdventurerMessage(..))
import Update.RouteUpdate exposing (parseLocation, Route, Route(..))
import Request.QuestsRequest exposing (getQuestsByUser)
import Types exposing (SessionModel, RecentPostedQuest)


type alias MyAdventurerModel =
    { quests : List RecentPostedQuest
    }


myAdventurerInitialModel =
    { quests = []
    }


onRouteChange : Route -> ( SessionModel, MyAdventurerModel ) -> List (Cmd Message) -> ( MyAdventurerModel, List (Cmd Message) )
onRouteChange route ( session, myAdventurer ) commands =
    case route of
        MyAdventurerRoute ->
            ( myAdventurer
            , commands
                ++ [ Cmd.map MyAdventurer
                        (getQuestsByUser
                            (Maybe.withDefault "" session.token)
                            (Maybe.withDefault "" session.userId)
                        )
                   ]
            )

        _ ->
            ( myAdventurer, commands )


onMyAdventurerMessage : MyAdventurerMessage -> MyAdventurerModel -> List (Cmd Message) -> ( MyAdventurerModel, List (Cmd Message) )
onMyAdventurerMessage myAdventurerMessage myAdventurer commands =
    case myAdventurerMessage of
        GetQuestsByUserResult (Result.Ok quests) ->
            ( { myAdventurer | quests = quests }, commands )

        GetQuestsByUserResult (Result.Err _) ->
            ( myAdventurer, commands )

        NoOp ->
            ( myAdventurer, commands )


myAdventurerUpdate : Message -> ( SessionModel, MyAdventurerModel ) -> List (Cmd Message) -> ( MyAdventurerModel, List (Cmd Message) )
myAdventurerUpdate message ( session, myAdventurer ) commands =
    case message of
        OnLocationChange location ->
            onRouteChange (parseLocation location) ( session, myAdventurer ) commands

        MyAdventurer myAdventurerMessage ->
            onMyAdventurerMessage myAdventurerMessage myAdventurer commands

        _ ->
            ( myAdventurer, commands )
