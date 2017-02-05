module Update exposing (..)

import Messages exposing (Msg(..), TacoMsg(..))
import Models exposing (Model, Taco)
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


updateTaco : TacoMsg -> Taco -> ( Taco, Cmd Msg )
updateTaco tacoMsg taco =
    case tacoMsg of
        NoOp ->
            ( taco, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( newModel, cmds, tacoMsg ) =
            updateModel msg model
    in
        let
            ( newTaco, tacoCmd ) =
                updateTaco tacoMsg newModel.taco
        in
            ( { newModel | taco = newTaco }, Cmd.batch [ cmds, tacoCmd ] )
