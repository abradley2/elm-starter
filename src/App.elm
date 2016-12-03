module App exposing (main)

import Html.App
import State exposing (initialState, update, subscriptions)
import View exposing (rootView)


main : Program Never
main =
    Html.App.program
        { init = ( initialState, Cmd.none )
        , update = update
        , subscriptions = subscriptions
        , view = rootView
        }
