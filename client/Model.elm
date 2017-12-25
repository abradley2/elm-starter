module Model exposing (Model, model)

import Update.HomeUpdate exposing (HomeModel, homeModel)


type alias Model =
    { homeModel : HomeModel
    , aboutModel : AboutModel
    }


model =
    { homeModel = homeModel
    , aboutModel = aboutModel
    }
