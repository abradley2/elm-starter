module Model exposing (Model, model)

import Routing exposing (Route, parseLocation)
import Update.HomeUpdate exposing (HomeModel, homeModel)
import Update.AboutUpdate exposing (AboutModel, aboutModel)


type alias Model =
    { route : Route
    , homeModel : HomeModel
    , aboutModel : AboutModel
    }


model route =
    { route = route
    , homeModel = homeModel
    , aboutModel = aboutModel
    }
