module Messages exposing (..)

import Home.Messages
import Ui.Messages


type Msg
    = HomeMsg Home.Messages.Msg
    | UiMsg Ui.Messages.Msg
