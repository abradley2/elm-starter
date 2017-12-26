module Model exposing (Model, model)

import Update.RouteUpdate exposing (RouteModel, routeModel)
import Update.HomeUpdate exposing (HomeModel, homeModel)
import Update.AboutUpdate exposing (AboutModel, aboutModel)
import Update.LayoutUpdate exposing (LayoutModel, layoutModel)


type alias Model =
    { routeModel : RouteModel
    , homeModel : HomeModel
    , aboutModel : AboutModel
    , layoutModel : LayoutModel
    }


model route =
    { routeModel = route
    , homeModel = homeModel
    , aboutModel = aboutModel
    , layoutModel = layoutModel
    }
