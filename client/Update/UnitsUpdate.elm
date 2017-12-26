module Update.UnitsUpdate exposing (UnitsModel, unitsUpdate, unitsModel)

import Message exposing (Message, Message(..))
import Message.UnitsMessage exposing (UnitsMessage, UnitsMessage(..))


type alias UnitsModel =
    {}


unitsModel : UnitsModel
unitsModel =
    {}


onUnitsMessage : UnitsMessage -> UnitsModel -> List (Cmd Message) -> ( UnitsModel, List (Cmd Message) )
onUnitsMessage unitsMessage unitsModel commands =
    case unitsMessage of
        NoOp ->
            ( unitsModel, commands )


unitsUpdate : Message -> UnitsModel -> List (Cmd Message) -> ( UnitsModel, List (Cmd Message) )
unitsUpdate message unitsModel commands =
    case message of
        Units unitsMessage ->
            onUnitsMessage unitsMessage unitsModel commands

        _ ->
            ( unitsModel, commands )
