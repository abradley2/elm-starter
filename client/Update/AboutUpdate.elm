module Update.AboutUpdate exposing (aboutModel, aboutUpdate)

import Message exposing (Message, Message(..))
import Message.AboutMessage exposing (AboutMessage(..))


type alias AboutModel =
    {}


aboutModel : AboutModel
aboutModel =
    {}


onAboutMessage : AboutMessage -> AboutModel -> ( AboutModel, List (Cmd Message) )
onAboutMessage aboutMessage aboutModel =
    case aboutMessage of
        NoOp ->
            ( aboutModel, [] )


aboutUpdate : Message -> AboutModel -> ( AboutModel, List (Cmd Message) )
aboutUpdate message aboutModel =
    case message of
        AboutMessage ->
            onAboutMessage message aboutModel

        _ ->
            ( aboutModel, [] )
