module Update.LayoutUpdate exposing (layoutUpdate, layoutModel, LayoutModel)

import Msg exposing (Msg, Msg(..))
import Msg.LayoutMsg exposing (LayoutMsg, LayoutMsg(..))


type alias LayoutModel =
    { sidenavOpen : Bool
    }


layoutModel =
    { sidenavOpen = False
    }


onLayoutMsg : LayoutMsg -> LayoutModel -> List (Cmd Msg) -> ( LayoutModel, List (Cmd Msg) )
onLayoutMsg layoutMsg layoutModel commands =
    case layoutMsg of
        ToggleSidenav ->
            ( { layoutModel
                | sidenavOpen = not layoutModel.sidenavOpen
              }
            , commands
            )


layoutUpdate : Msg -> LayoutModel -> List (Cmd Msg) -> ( LayoutModel, List (Cmd Msg) )
layoutUpdate msg layoutModel commands =
    case msg of
        Layout layoutMsg ->
            onLayoutMsg layoutMsg layoutModel commands

        _ ->
            ( layoutModel, commands )
