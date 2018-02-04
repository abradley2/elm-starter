module Model exposing (Model, model)

import Update.LayoutUpdate exposing (LayoutModel, layoutModel)
import Update.MyAdventurerUpdate exposing (MyAdventurerModel, myAdventurerInitialModel)
import Update.CreateQuestUpdate exposing (CreateQuestModel, createQuestInitialModel)
import Update.QuestsUpdate exposing (QuestsModel, questsModel)
import Update.SideQuestsUpdate exposing (SideQuestsModel, sideQuestsModel)
import Update.SessionUpdate exposing (sessionInitialModel)
import Update.RouteUpdate exposing (RouteData)
import Types exposing (SessionModel)


type alias Model =
    { routeData : RouteData
    , quests : QuestsModel
    , myAdventurer : MyAdventurerModel
    , sideQuests : SideQuestsModel
    , layout : LayoutModel
    , session : SessionModel
    , createQuest : CreateQuestModel
    }


model initialLocation =
    { routeData = initialLocation
    , quests = questsModel
    , myAdventurer = myAdventurerInitialModel
    , sideQuests = sideQuestsModel
    , layout = layoutModel
    , session = sessionInitialModel
    , createQuest = createQuestInitialModel
    }
