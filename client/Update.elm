module Update exposing (update)

import Message exposing (Message, Message(..))
import Routing exposing (parseLocation)
import Update.HomeUpdate exposing (homeUpdate)
import Update.AboutUpdate exposing (aboutUpdate)


updater getter setter reducer =
    \( message, model, commands ) ->
        let
            ( newModel, newCommands ) =
                reducer message (getter model)
        in
            ( message, setter model newModel, newCommands )


update message model =
    case message of
        OnLocationChange location ->
            let
                newLocation =
                    location
            in
                ( { model | route = parseLocation newLocation }, Cmd.none )

        _ ->
            let
                ( passMessage, updatedModel, commands ) =
                    ( message, model, [] )
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
