module Model exposing (Model, model)

import Update.RouteUpdate exposing (Route)
import Update.ArmiesUpdate exposing (ArmiesModel, armiesModel)
import Update.UnitsUpdate exposing (UnitsModel, unitsModel)
import Update.LayoutUpdate exposing (LayoutModel, layoutModel)
import Update.UserUpdate exposing (UserModel, userModel)
import Update.ComponentsUpdate exposing (ComponentsModel, componentsModel)


type alias Model =
    { route : Route
    , armies : ArmiesModel
    , units : UnitsModel
    , layout : LayoutModel
    , user : UserModel
    , components : ComponentsModel
    }


model initialLocation =
    { route = initialLocation
    , armies = armiesModel
    , units = unitsModel
    , layout = layoutModel
    , user = userModel
    , components = componentsModel
    }
