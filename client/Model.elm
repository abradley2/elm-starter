module Model exposing (Model, model)

import Update.HomeUpdate exposing (HomeModel, homeModel)
import Update.AboutUpdate exposing (AboutModel, aboutModel)


type alias Model =
    { homeModel : HomeModel
    , aboutModel : AboutModel
    }


model =
    { homeModel = homeModel
    , aboutModel = aboutModel
    }
