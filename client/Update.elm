module Update exposing (update)

import Message exposing (Message, Message(..))
import Update.UnitsUpdate exposing (unitsModel, unitsUpdate)
import Update.ArmiesUpdate exposing (armiesUpdate)
import Update.LayoutUpdate exposing (layoutUpdate)
import Update.RouteUpdate exposing (routeUpdate)
import Update.UserUpdate exposing (userUpdate)


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
                    (\model -> model.unitsModel)
                    (\model unitsModel -> ({ model | unitsModel = unitsModel }))
                    unitsUpdate
                |> updater
                    (\model -> model.armiesModel)
                    (\model armiesModel -> ({ model | armiesModel = armiesModel }))
                    armiesUpdate
                |> updater
                    (\model -> model.layoutModel)
                    (\model layoutModel -> ({ model | layoutModel = layoutModel }))
                    layoutUpdate
                |> updater
                    (\model -> model.userModel)
                    (\model userModel -> ({ model | userModel = userModel }))
                    userUpdate
    in
        ( updatedModel, Cmd.batch commands )
