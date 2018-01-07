module Update.SideQuestsUpdate exposing (SideQuestsModel, sideQuestsUpdate, sideQuestsModel)

import Message exposing (Message, Message(..))
import Message.SideQuestsMessage exposing (SideQuestsMessage, SideQuestsMessage(..))


type alias SideQuestsModel =
    {}


sideQuestsModel : SideQuestsModel
sideQuestsModel =
    {}


onSideQuestsMessage : SideQuestsMessage -> SideQuestsModel -> List (Cmd Message) -> ( SideQuestsModel, List (Cmd Message) )
onSideQuestsMessage sideQuestsMessage sideQuests commands =
    case sideQuestsMessage of
        NoOp ->
            ( sideQuests, commands )


sideQuestsUpdate : Message -> SideQuestsModel -> List (Cmd Message) -> ( SideQuestsModel, List (Cmd Message) )
sideQuestsUpdate message sideQuests commands =
    case message of
        SideQuests sideQuestsMessage ->
            onSideQuestsMessage sideQuestsMessage sideQuests commands

        _ ->
            ( sideQuests, commands )
