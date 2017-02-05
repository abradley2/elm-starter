module Update exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model)
import Home.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HomeMsg msg ->
            let
                ( home, cmd ) =
                    Home.Update.update model.home msg
            in
                ( { model | home = home }, Cmd.map HomeMsg cmd )

        AppMsg ->
            ( model, Cmd.none )
