module Update exposing (update)

import Msg exposing (Msg, Msg(..))
import Update.SideQuestsUpdate exposing (sideQuestsModel, sideQuestsUpdate)
import Update.QuestsUpdate exposing (questsUpdate)
import Update.LayoutUpdate exposing (layoutUpdate)
import Update.RouteUpdate exposing (routeUpdate)
import Update.CreateQuestUpdate exposing (createQuestUpdate)
import Update.SessionUpdate exposing (tacoUpdate)
import Update.MyAdventurerUpdate exposing (myAdventurerUpdate)
import Update.QuestDetailsUpdate exposing (questDetailsUpdate)


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
                    (\model -> model.routeData)
                    (\model routeData -> ({ model | routeData = routeData }))
                    routeUpdate
                |> updater
                    (\model -> ( model.routeData, model.taco ))
                    (\model taco -> ({ model | taco = taco }))
                    tacoUpdate
                |> updater
                    (\model -> ( model.taco, model.sideQuests ))
                    (\model sideQuests -> ({ model | sideQuests = sideQuests }))
                    sideQuestsUpdate
                |> updater
                    (\model -> ( model.taco, model.quests ))
                    (\model quests -> ({ model | quests = quests }))
                    questsUpdate
                |> updater
                    (\model -> model.layout)
                    (\model layout -> ({ model | layout = layout }))
                    layoutUpdate
                |> updater
                    (\model -> ( model.taco, model.createQuest ))
                    (\model createQuest -> ({ model | createQuest = createQuest }))
                    createQuestUpdate
                |> updater
                    (\model -> ( model.taco, model.myAdventurer ))
                    (\model myAdventurer -> ({ model | myAdventurer = myAdventurer }))
                    myAdventurerUpdate
                |> updater
                    (\model -> ( model.taco, model.questDetails ))
                    (\model questDetails -> ({ model | questDetails = questDetails }))
                    questDetailsUpdate
    in
        ( updatedModel, Cmd.batch commands )
