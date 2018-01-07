module Update.ComponentsUpdate exposing (componentsUpdate, componentsModel, ComponentsModel)

import Message exposing (Message, Message(..))


type alias ComponentsModel =
    {}


componentsModel =
    {}


componentsUpdate : Message -> ComponentsModel -> List (Cmd Message) -> ( ComponentsModel, List (Cmd Message) )
componentsUpdate message components commands =
    case message of
        Mount componentId ->
            ( components, commands )

        Unmount componentId ->
            ( components, commands )

        _ ->
            ( components, commands )
