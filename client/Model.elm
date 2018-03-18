module Model exposing (Model, model)

import Update.LayoutUpdate exposing (LayoutModel, layoutModel)
import Update.MyAdventurerUpdate exposing (MyAdventurerModel, myAdventurerInitialModel)
import Update.CreateQuestUpdate exposing (CreateQuestModel, createQuestInitialModel)
import Update.QuestsUpdate exposing (QuestsModel, questsModel)
import Update.SideQuestsUpdate exposing (SideQuestsModel, sideQuestsModel)
import Update.QuestDetailsUpdate exposing (QuestDetailsModel, questDetailsInitialModel)
import Update.SessionUpdate exposing (tacoInitialModel)
import Types exposing (Taco, RouteData)


type alias Model =
    { routeData : RouteData
    , quests : QuestsModel
    , myAdventurer : MyAdventurerModel
    , sideQuests : SideQuestsModel
    , layout : LayoutModel
    , taco : Taco
    , createQuest : CreateQuestModel
    , questDetails : QuestDetailsModel
    }


model flags initialLocation =
    { routeData = initialLocation
    , quests = questsModel
    , myAdventurer = myAdventurerInitialModel
    , sideQuests = sideQuestsModel
    , layout = layoutModel
    , taco = tacoInitialModel flags initialLocation
    , createQuest = createQuestInitialModel
    , questDetails = questDetailsInitialModel
    }
