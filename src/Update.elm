module Update exposing (..)

import Messages exposing (Msg(..), TacoMsg(..))
import Models exposing (Taco, Model)
import Home.Update


updateModel : Msg -> Model -> ( Model, Cmd Msg, TacoMsg )
updateModel msg model =
    case msg of
        HomeMsg msg ->
            let
                ( home, cmd, tacoMsg ) =
                    Home.Update.update model.home msg
            in
                ( { model | home = home }, Cmd.map HomeMsg cmd, tacoMsg )


updateTaco : TacoMsg -> Taco -> Taco
updateTaco tacoMsg taco =
    case tacoMsg of
        NoOp ->
            taco


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( model, cmds, tacoMsg ) =
            updateModel msg model
    in
        ( { model | taco = updateTaco tacoMsg }, cmds )
