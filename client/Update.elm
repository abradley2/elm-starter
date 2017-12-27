module Update exposing (update)

import Message exposing (Message, Message(..))
import Update.UnitsUpdate exposing (unitsModel, unitsUpdate)
import Update.HomeUpdate exposing (homeUpdate)
import Update.LayoutUpdate exposing (layoutUpdate)
import Update.RouteUpdate exposing (routeUpdate)


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
                    (\model -> model.routeModel)
                    (\model routeModel -> ({ model | routeModel = routeModel }))
                    routeUpdate
                |> updater
                    (\model -> model.unitsModel)
                    (\model unitsModel -> ({ model | unitsModel = unitsModel }))
                    unitsUpdate
                |> updater
                    (\model -> model.homeModel)
                    (\model homeModel -> ({ model | homeModel = homeModel }))
                    homeUpdate
                |> updater
                    (\model -> model.layoutModel)
                    (\model layoutModel -> ({ model | layoutModel = layoutModel }))
                    layoutUpdate
    in
        ( updatedModel, Cmd.batch commands )
