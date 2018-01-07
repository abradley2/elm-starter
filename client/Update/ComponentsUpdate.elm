module Update.ComponentsUpdate exposing (componentsUpdate, Components, components)

import Dict exposing (Dict)
import Message exposing (Message, Message(..))


type alias ComponentDictionary =
    Dict String (Dict String (Dict String String))


type alias Components =
    { textFields : ComponentDictionary
    }


components : Components
components =
    { textFields = Dict.empty
    }


type alias ComponentsModel baseModel =
    { baseModel
        | components : Components
    }


componentsModel initialModel =
    let
        formedModel =
            { initialModel | components = components }
    in
        formedModel


componentsUpdate updater message modelWithComponents commands =
    case message of
        Mount message ->
            ( modelWithComponents, commands )

        Unmount message ->
            ( modelWithComponents, commands )

        _ ->
            updater message modelWithComponents commands
