module Update exposing (Model, Msg)

import Taco exposing (Taco, taco, TacoMsg(..))
import Pages.Home exposing (HomeModel, HomeMsg)


type Msg
    = HomeMsg


type alias Model =
    { taco : Taco
    , home : HomeModel
    }


model : Model
model =
    { home = Pages.Home.model
    , taco = taco
    }


updateModel : Msg -> Model -> ( Model, Cmd Msg, TacoMsg )
updateModel msg model =
    case msg of
        HomeMsg ->
            let
                ( home, cmd, tacoMsg ) =
                    Pages.Home.update model.home msg
            in
                ( { model | home = home }, Cmd.none, tacoMsg )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( newModel, cmds, tacoMsg ) =
            updateModel msg model
    in
        ( { newModel | taco = Taco.update tacoMsg newModel.taco }, cmds )
