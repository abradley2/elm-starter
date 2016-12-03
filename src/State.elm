module State exposing (initialState, subscriptions, update)

import Types exposing (..)
import Mouse
import Keyboard
import Login.State
import Login.Types


initialState : Model
initialState =
    { login =
        { username = ""
        , password = ""
        }
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( newModel, commands ) =
            ( model, [] )
                |> Login.State.update msg
    in
        ( newModel, Cmd.batch commands )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Mouse.clicks MouseMsg
        , Keyboard.downs KeyMsg
        ]
