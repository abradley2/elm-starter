module Update exposing (Model, Msg, model, update, view)

import Taco exposing (Taco, taco, TacoMsg(..))
import Html exposing (..)
import Pages.Home


type Msg
    = HomeMsg Pages.Home.HomeMsg


type alias Model =
    { taco : Taco
    , home : Pages.Home.Model
    }


model : Model
model =
    { home = Pages.Home.model
    , taco = taco
    }


updateModel : Msg -> Model -> ( Model, Cmd Msg, TacoMsg )
updateModel msg model =
    case msg of
        HomeMsg msg ->
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


view : Model -> Html Msg
view model =
    Html.map (\msg -> HomeMsg msg) (Pages.Home.view model.home)
