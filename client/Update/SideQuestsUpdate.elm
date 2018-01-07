module Update.SideQuestsUpdate exposing (SideQuestsModel, sideQuestsUpdate, sideQuestsModel)

import Message exposing (Message, Message(..))
import Message.SideQuestsMessage exposing (SideQuestsMessage, SideQuestsMessage(..))


type alias SideQuestsModel =
    {}


sideQuestsModel : SideQuestsModel
sideQuestsModel =
    {}


onUnitsMessage : SideQuestsMessage -> SideQuestsModel -> List (Cmd Message) -> ( SideQuestsModel, List (Cmd Message) )
onUnitsMessage unitsMessage sideQuestsModel commands =
    case unitsMessage of
        NoOp ->
            ( sideQuestsModel, commands )


sideQuestsUpdate : Message -> SideQuestsModel -> List (Cmd Message) -> ( SideQuestsModel, List (Cmd Message) )
sideQuestsUpdate message sideQuestsModel commands =
    case message of
        Units unitsMessage ->
            onUnitsMessage unitsMessage sideQuestsModel commands

        _ ->
            ( sideQuestsModel, commands )
