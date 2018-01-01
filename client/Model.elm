module Model exposing (Model, model)

import Update.RouteUpdate exposing (RouteModel, routeModel)
import Update.ArmiesUpdate exposing (ArmiesModel, armiesModel)
import Update.UnitsUpdate exposing (UnitsModel, unitsModel)
import Update.LayoutUpdate exposing (LayoutModel, layoutModel)
import Update.UserUpdate exposing (UserModel, userModel)


type alias Model =
    { routeModel : RouteModel
    , armiesModel : ArmiesModel
    , unitsModel : UnitsModel
    , layoutModel : LayoutModel
    , userModel : UserModel
    }


model route =
    { routeModel = route
    , armiesModel = armiesModel
    , unitsModel = unitsModel
    , layoutModel = layoutModel
    , userModel = userModel
    }
