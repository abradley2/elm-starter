module Update.ArmiesUpdate exposing (armiesModel, armiesUpdate, ArmiesModel)

import Message exposing (Message, Message(..))
import Message.ArmiesMessage exposing (ArmiesMessage(..))


type alias ArmiesModel =
    { armies : List String
    }


armiesModel : ArmiesModel
armiesModel =
    { armies = []
    }


onArmiesMessage : ArmiesMessage -> ArmiesModel -> List (Cmd Message) -> ( ArmiesModel, List (Cmd Message) )
onArmiesMessage armiesMessage armiesModel commands =
    case armiesMessage of
        GetArmiesResult (Result.Ok armies) ->
            ( { armiesModel | armies = armies }, commands )

        GetArmiesResult (Result.Err _) ->
            ( armiesModel, commands )

        NoOp ->
            ( armiesModel, commands )


armiesUpdate : Message -> ArmiesModel -> List (Cmd Message) -> ( ArmiesModel, List (Cmd Message) )
armiesUpdate message armiesModel commands =
    case message of
        Armies armiesMessage ->
            onArmiesMessage armiesMessage armiesModel commands

        _ ->
            ( armiesModel, commands )
