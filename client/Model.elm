module Model exposing (Model, model)

import Update.RouteUpdate exposing (RouteModel, routeModel)
import Update.HomeUpdate exposing (HomeModel, homeModel)
import Update.UnitsUpdate exposing (UnitsModel, unitsModel)
import Update.LayoutUpdate exposing (LayoutModel, layoutModel)


type alias Model =
    { routeModel : RouteModel
    , homeModel : HomeModel
    , unitsModel : UnitsModel
    , layoutModel : LayoutModel
    }


model route =
    { routeModel = route
    , homeModel = homeModel
    , unitsModel = unitsModel
    , layoutModel = layoutModel
    }
