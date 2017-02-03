module Update exposing (..)

import Messages exposing (Msg, Msg(..))
import Models exposing (Model)
import Home.Update


update : Msg -> Model -> ( Model, Cmd AppMsg )
update msg model =
    case msg of
        HomeMsg subMsg ->
            let
                ( home, cmd ) =
                    Home.Update.update subMsg model.home
            in
                ( { model | home = home }, Cmd.map HomeMsg cmd )

        AppMsg ->
            ( model, Cmd.none )
