module Home.Update exposing (..)

import Home.Models exposing (HomeModel)
import Home.Messages exposing (Msg(..))
import Messages exposing (TacoMsg(..))


update : HomeModel -> Msg -> ( HomeModel, Cmd Msg, TacoMsg )
update homeModel message =
    case message of
        EditMessage message ->
            ( { homeModel | message = message }, Cmd.none, NoOp_ )

        EditTacoMessage message ->
            ( homeModel, Cmd.none, EditMessage_ message )

        NoOp ->
            ( homeModel, Cmd.none, NoOp_ )
