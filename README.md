# Elm Starter

# Folder structure

We divide our application into three seperate folders apart from our root directory.

1) Message
2) Update
3) View

## Message

Updaters do not own messages. Messages are completely agnostic to what updates will
occur. Messages are just events and events do not know the future or how we wish to respond
to them.

We will therefore have messages separate from Updaters. Any updater can respond to any
Message- even if they are all limited to only affecting their own slice of the Model.
A Message such as `USER_LOGGED_OUT` for example will effect many parts of our Model,
and given Updaters divide responsibility of our Model we don't want to limit an Updater
to any subset of Messages.

Bundling Messages with Updaters is a bad idea. It is perfectly legitimate for two Updaters
to respond to Messages that the other responds to as well, and if we bundle these together
than we create a chance for a circular dependency.

## Updaters




Here is how we `combineReducers` so to speak
(I legitimately could not find a less repetitive way to do this. I tried. Sorry.):

```
module Update exposing (update)

import Message exposing (Message, Message(..))
import Update.RouteUpdate exposing (routeUpdate)
import Update.HomeUpdate exposing (homeUpdate)
import Update.AboutUpdate exposing (aboutUpdate)
import Update.LayoutUpdate exposing (layoutUpdate)


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
                    aboutUpdate
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
```

Anytime we have a new updater we need to add the 4 corresponding lines here. They're
boilerplate but as far as boilerplate goes, 4 lines isn't bad
