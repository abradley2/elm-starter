module Model exposing (Model, model)

import Update.LayoutUpdate exposing (LayoutModel, layoutModel)
import Update.MyAdventurerUpdate exposing (MyAdventurerModel, myAdventurerInitialModel)
import Update.QuestsUpdate exposing (QuestsModel, questsModel)
import Update.RouteUpdate exposing (Route)
import Update.SessionUpdate exposing (SessionModel, sessionModel)
import Update.SideQuestsUpdate exposing (SideQuestsModel, sideQuestsModel)


type alias Model =
    { route : Route
    , quests : QuestsModel
    , myAdventurer : MyAdventurerModel
    , units : SideQuestsModel
    , layout : LayoutModel
    , session : SessionModel
    }


model initialLocation =
    { route = initialLocation
    , quests = questsModel
    , myAdventurer = myAdventurerInitialModel
    , units = sideQuestsModel
    , layout = layoutModel
    , session = sessionModel
    }
