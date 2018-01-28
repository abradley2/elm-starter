module Update exposing (update)

import Message exposing (Message, Message(..))
import Update.SideQuestsUpdate exposing (sideQuestsModel, sideQuestsUpdate)
import Update.QuestsUpdate exposing (questsUpdate)
import Update.LayoutUpdate exposing (layoutUpdate)
import Update.RouteUpdate exposing (routeUpdate)
import Update.CreateQuestUpdate exposing (createQuestUpdate)
import Update.SessionUpdate exposing (sessionUpdate)
import Update.MyAdventurerUpdate exposing (myAdventurerUpdate)


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
            ( Debug.log "message" message, model, [] )
                |> updater
                    (\model -> model.session)
                    (\model session -> ({ model | session = session }))
                    sessionUpdate
                |> updater
                    (\model -> model.route)
                    (\model route -> ({ model | route = route }))
                    routeUpdate
                |> updater
                    (\model -> model.sideQuests)
                    (\model sideQuests -> ({ model | sideQuests = sideQuests }))
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
                    (\model -> model.createQuest)
                    (\model createQuest -> ({ model | createQuest = createQuest }))
                    createQuestUpdate
                |> updater
                    (\model -> ( model.session, model.myAdventurer ))
                    (\model myAdventurer -> ({ model | myAdventurer = myAdventurer }))
                    myAdventurerUpdate
    in
        ( updatedModel, Cmd.batch commands )
