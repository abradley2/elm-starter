module Util exposing (..)


getReducerFactory model taco tacoCmd =
    (\messageType pageModel setter reducer ->
        let
            ( updatedPageModel, cmd ) =
                reducer ( pageModel, taco )
        in
            ( setter model updatedPageModel, Cmd.batch [ tacoCmd, Cmd.map messageType cmd ] )
    )
