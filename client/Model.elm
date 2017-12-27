module Model exposing (Model, model)

import Update.RouteUpdate exposing (RouteModel, routeModel)
import Update.ArmiesUpdate exposing (ArmiesModel, armiesModel)
import Update.UnitsUpdate exposing (UnitsModel, unitsModel)
import Update.LayoutUpdate exposing (LayoutModel, layoutModel)


type alias Model =
    { routeModel : RouteModel
    , armiesModel : ArmiesModel
    , unitsModel : UnitsModel
    , layoutModel : LayoutModel
    }


model route =
    { routeModel = route
    , armiesModel = armiesModel
    , unitsModel = unitsModel
    , layoutModel = layoutModel
    }
