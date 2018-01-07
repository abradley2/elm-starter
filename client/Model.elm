module Model exposing (Model, model)

import Update.RouteUpdate exposing (Route)
import Update.QuestsUpdate exposing (QuestsModel, questsModel)
import Update.SideQuestsUpdate exposing (SideQuestsModel, sideQuestsModel)
import Update.LayoutUpdate exposing (LayoutModel, layoutModel)
import Update.SessionUpdate exposing (SessionModel, sessionModel)
import Update.ComponentsUpdate exposing (ComponentsModel, componentsModel)


type alias Model =
    { route : Route
    , quests : QuestsModel
    , units : SideQuestsModel
    , layout : LayoutModel
    , user : SessionModel
    , components : ComponentsModel
    }


model initialLocation =
    { route = initialLocation
    , quests = questsModel
    , units = sideQuestsModel
    , layout = layoutModel
    , user = sessionModel
    , components = componentsModel
    }
