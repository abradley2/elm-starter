module Update exposing (update)

import Message exposing (Message, Message(..))
import Update.SideQuestsUpdate exposing (sideQuestsModel, sideQuestsUpdate)
import Update.QuestsUpdate exposing (questsUpdate)
import Update.LayoutUpdate exposing (layoutUpdate)
import Update.RouteUpdate exposing (routeUpdate)
import Update.SessionUpdate exposing (sessionUpdate)
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
                    sideQuestsUpdate
                |> updater
                    (\model -> model.quests)
                    (\model quests -> ({ model | quests = quests }))
                    questsUpdate
                |> updater
                    (\model -> model.layout)
                    (\model layout -> ({ model | layout = layout }))
                    layoutUpdate
                |> updater
                    (\model -> model.user)
                    (\model user -> ({ model | user = user }))
                    sessionUpdate
                |> updater
                    (\model -> model.components)
                    (\model components -> ({ model | components = components }))
                    componentsUpdate
    in
        ( updatedModel, Cmd.batch commands )
