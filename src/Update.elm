module Update exposing (..)

import Messages exposing (Msg(..))
import Models exposing (Model)
import Home.Update


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        HomeMsg subMsg ->
            let
                ( updatedPeople, cmd ) =
                    Home.Update.update subMsg model.people
            in
                ( { model | people = updatedPeople }, Cmd.map HomeMsg cmd )
