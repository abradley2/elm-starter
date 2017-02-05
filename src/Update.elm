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


updateTaco : TacoMsg -> Taco -> Taco
updateTaco msg taco =
    case msg of
        EditMessage_ message ->
            { taco | message = message }

        NoOp_ ->
            taco


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( newModel, cmds, tacoMsg ) =
            updateModel msg model
    in
        ( { newModel | taco = updateTaco tacoMsg newModel.taco }, cmds )
