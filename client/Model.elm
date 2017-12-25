module Model exposing (Model, model)

import Update.RouteUpdate exposing (RouteModel, routeModel)
import Update.HomeUpdate exposing (HomeModel, homeModel)
import Update.AboutUpdate exposing (AboutModel, aboutModel)


type alias Model =
    { routeModel : RouteModel
    , homeModel : HomeModel
    , aboutModel : AboutModel
    }


model route =
    { routeModel = route
    , homeModel = homeModel
    , aboutModel = aboutModel
    }
