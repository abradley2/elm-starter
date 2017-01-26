module Home.Update exposing (..)

import Home.Messages exposing (Msg(..))
import Home.Models exposing (Person)


update : Msg -> List Person -> ( List Person, Cmd Msg )
update message people =
    case message of
        NoOp ->
            ( people, Cmd.none )
