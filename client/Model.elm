module Model exposing (Model, model)

import Update.LayoutUpdate exposing (LayoutModel, layoutModel)
import Update.MyAdventurerUpdate exposing (MyAdventurerModel, myAdventurerInitialModel)
import Update.CreateQuestUpdate exposing (CreateQuestModel, createQuestInitialModel)
import Update.QuestsUpdate exposing (QuestsModel, questsModel)
import Update.RouteUpdate exposing (Route)
import Update.SessionUpdate exposing (SessionModel, sessionModel)
import Update.SideQuestsUpdate exposing (SideQuestsModel, sideQuestsModel)


type alias Model =
    { route : Route
    , quests : QuestsModel
    , myAdventurer : MyAdventurerModel
    , sideQuests : SideQuestsModel
    , layout : LayoutModel
    , session : SessionModel
    , createQuest : CreateQuestModel
    }


model initialLocation =
    { route = initialLocation
    , quests = questsModel
    , myAdventurer = myAdventurerInitialModel
    , sideQuests = sideQuestsModel
    , layout = layoutModel
    , session = sessionModel
    , createQuest = createQuestInitialModel
    }
