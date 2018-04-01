module Update.LayoutUpdate
    exposing
        ( layoutUpdate
        , layoutModel
        , LayoutModel
        , LayoutMsg
        , LayoutMsg(..)
        )

import Types exposing (Taco, TacoMsg)


type LayoutMsg
    = ToggleSidenav


type alias LayoutModel =
    { sidenavOpen : Bool
    }


layoutModel =
    { sidenavOpen = False
    }


layoutUpdate : LayoutMsg -> TacoMsg -> LayoutModel -> Taco -> ( LayoutModel, Cmd LayoutMsg )
layoutUpdate msg tacoMsg layoutModel taco =
    case msg of
        ToggleSidenav ->
            ( { layoutModel
                | sidenavOpen = not layoutModel.sidenavOpen
              }
            , Cmd.none
            )
