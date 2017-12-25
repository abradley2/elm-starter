module Update.AboutUpdate exposing (aboutModel, aboutUpdate, AboutModel)

import Message exposing (Message, Message(..))
import Message.AboutMessage exposing (AboutMessage(..))


type alias AboutModel =
    {}


aboutModel : AboutModel
aboutModel =
    {}


onAboutMessage : AboutMessage -> AboutModel -> List (Cmd Message) -> ( AboutModel, List (Cmd Message) )
onAboutMessage aboutMessage aboutModel commands =
    case aboutMessage of
        NoOp ->
            ( aboutModel, commands )


aboutUpdate : Message -> AboutModel -> List (Cmd Message) -> ( AboutModel, List (Cmd Message) )
aboutUpdate message aboutModel commands =
    case message of
        About aboutMessage ->
            onAboutMessage aboutMessage aboutModel commands

        _ ->
            ( aboutModel, commands )
