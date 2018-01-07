module Update exposing (update)

import Message exposing (Message, Message(..))
import Update.UnitsUpdate exposing (unitsModel, unitsUpdate)
import Update.ArmiesUpdate exposing (armiesUpdate)
import Update.LayoutUpdate exposing (layoutUpdate)
import Update.RouteUpdate exposing (routeUpdate)
import Update.UserUpdate exposing (userUpdate)
import Update.ComponentsUpdate exposing (componentsUpdate)


updater getter setter reducer =
    \( message, model, commands ) ->
        let
            ( newModel, newCommands ) =
                reducer (message) (getter model) commands
        in
            ( message, setter model newModel, newCommands )


update message model =
    let
        ( passMessage, updatedModel, commands ) =
            ( Debug.log "message:" message, model, [] )
                |> updater
                    (\model -> model.route)
                    (\model route -> ({ model | route = route }))
                    routeUpdate
                |> updater
                    (\model -> model.units)
                    (\model units -> ({ model | units = units }))
                    unitsUpdate
                |> updater
                    (\model -> model.armies)
                    (\model armies -> ({ model | armies = armies }))
                    armiesUpdate
                |> updater
                    (\model -> model.layout)
                    (\model layout -> ({ model | layout = layout }))
                    layoutUpdate
                |> updater
                    (\model -> model.user)
                    (\model user -> ({ model | user = user }))
                    userUpdate
                |> updater
                    (\model -> model.components)
                    (\model components -> ({ model | components = components }))
                    componentsUpdate
    in
        ( updatedModel, Cmd.batch commands )
