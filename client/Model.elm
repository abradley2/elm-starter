module Model exposing (Model, model)

import Update.RouteUpdate exposing (Route)
import Update.ArmiesUpdate exposing (ArmiesModel, armiesModel)
import Update.UnitsUpdate exposing (UnitsModel, unitsModel)
import Update.LayoutUpdate exposing (LayoutModel, layoutModel)
import Update.UserUpdate exposing (UserModel, userModel)


type alias Model =
    { route : Route
    , armiesModel : ArmiesModel
    , unitsModel : UnitsModel
    , layoutModel : LayoutModel
    , userModel : UserModel
    }


model initialLocation =
    { route = initialLocation
    , armiesModel = armiesModel
    , unitsModel = unitsModel
    , layoutModel = layoutModel
    , userModel = userModel
    }
