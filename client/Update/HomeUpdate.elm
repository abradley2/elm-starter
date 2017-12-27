module Update.ArmiesUpdate exposing (armiesModel, armiesUpdate, ArmiesModel)

import Message exposing (Message, Message(..))
import Message.ArmiesMessage exposing (ArmiesMessage(..))


type alias ArmiesModel =
    {}


armiesModel : ArmiesModel
armiesModel =
    {}


onArmiesMessage : ArmiesMessage -> ArmiesModel -> List (Cmd Message) -> ( ArmiesModel, List (Cmd Message) )
onArmiesMessage armiesMessage armiesModel commands =
    case armiesMessage of
        NoOp ->
            ( armiesModel, commands )


armiesUpdate : Message -> ArmiesModel -> List (Cmd Message) -> ( ArmiesModel, List (Cmd Message) )
armiesUpdate message armiesModel commands =
    case message of
        Armies armiesMessage ->
            onArmiesMessage armiesMessage armiesModel commands

        _ ->
            ( armiesModel, commands )
