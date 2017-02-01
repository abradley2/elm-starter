module Home.Update exposing (..)

import Http
import Home.Messages exposing (Msg(..))
import Home.Models exposing (HomeModel)
import List exposing (..)
import Json.Decode exposing (..)


update : Msg -> HomeModel -> ( HomeModel, Cmd Msg )
update message homeModel =
    case message of
        EditMessage message ->
            ( { homeModel | message = message }, Cmd.none )

        NoOp ->
            ( homeModel, Cmd.none )
