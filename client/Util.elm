module Util exposing (..)

import Types exposing (TacoMsg(..))


getReducerFactory model taco tacoCmd commands =
    (\messageType pageModel setter reducer ->
        let
            ( updatedPageModel, cmd ) =
                reducer ( pageModel, taco )
        in
            ( setter model updatedPageModel, Cmd.batch [ tacoCmd, Cmd.map messageType cmd, commands ] )
    )


onTacoUpdate tacoMsg taco messageType getter setter reducer =
    case tacoMsg of
        TacoNoOp ->
            (\( model, commands ) -> ( model, commands ))

        _ ->
            (\( model, commands ) ->
                let
                    ( updatedPageModel, cmd ) =
                        reducer ( getter model, taco )
                in
                    ( setter model updatedPageModel, Cmd.batch [ Cmd.map messageType cmd, commands ] )
            )
