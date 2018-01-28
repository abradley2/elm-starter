module Update.MyAdventurerUpdate
    exposing
        ( myAdventurerUpdate
        , myAdventurerInitialModel
        , MyAdventurerModel
        )

import Message exposing (Message, Message(..))
import Message.MyAdventurerMessage exposing (MyAdventurerMessage, MyAdventurerMessage(..))
import Types exposing (SessionModel)


type alias MyAdventurerModel =
    {}


myAdventurerInitialModel =
    {}


onMyAdventurerMessage : MyAdventurerMessage -> MyAdventurerModel -> List (Cmd Message) -> ( MyAdventurerModel, List (Cmd Message) )
onMyAdventurerMessage myAdventurerMessage myAdventurer commands =
    case myAdventurerMessage of
        NoOp ->
            ( myAdventurer, commands )


myAdventurerUpdate : Message -> ( SessionModel, MyAdventurerModel ) -> List (Cmd Message) -> ( MyAdventurerModel, List (Cmd Message) )
myAdventurerUpdate message ( token, myAdventurer ) commands =
    case message of
        MyAdventurer myAdventurerMessage ->
            onMyAdventurerMessage myAdventurerMessage myAdventurer commands

        _ ->
            ( myAdventurer, commands )
