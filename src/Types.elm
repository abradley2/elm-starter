module Types exposing (..)

import Mouse
import Keyboard
import Login.Types


type Msg
    = MouseMsg Mouse.Position
    | KeyMsg Keyboard.KeyCode
    | LoginMsg Login.Types.LoginMsg


type alias Model =
    { login : Login.Types.LoginModel
    }
