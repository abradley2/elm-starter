module Update exposing (update)

import Message exposing (Message, Message(..))
import Update.RouteUpdate exposing (routeUpdate)
import Update.HomeUpdate exposing (homeUpdate)
import Update.AboutUpdate exposing (aboutUpdate)


updater getter setter reducer =
    \( message, model, commands ) ->
        let
            ( newModel, newCommands ) =
                reducer message (getter model) commands
        in
            ( message, setter model newModel, newCommands )


update message model =
    let
        ( passMessage, updatedModel, commands ) =
            ( message, model, [] )
                |> updater
                    (\model -> model.routeModel)
                    (\model routeModel -> ({ model | routeModel = routeModel }))
                    routeUpdate
                |> updater
                    (\model -> model.aboutModel)
                    (\model aboutModel -> ({ model | aboutModel = aboutModel }))
                    aboutUpdate
                |> updater
                    (\model -> model.homeModel)
                    (\model homeModel -> ({ model | homeModel = homeModel }))
                    homeUpdate
    in
        ( updatedModel, Cmd.batch commands )
