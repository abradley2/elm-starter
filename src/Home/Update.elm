module Home.Update exposing (..)

import Home.Models exposing (HomeModel)
import Home.Messages exposing (Msg(..))


update : HomeModel -> Msg -> ( HomeModel, Cmd AppMsg )
update homeModel message =
    case message of
        EditMessage message ->
            ( { homeModel | message = message }, Cmd.none )

        NoOp ->
            ( hommeModel, Cmd.none )
