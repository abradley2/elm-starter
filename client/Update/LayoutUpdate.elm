module Update.LayoutUpdate
    exposing
        ( onUpdate
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


onUpdate : LayoutMsg -> TacoMsg -> LayoutModel -> Taco -> ( LayoutModel, Cmd LayoutMsg )
onUpdate msg tacoMsg layoutModel taco =
    case msg of
        ToggleSidenav ->
            ( { layoutModel
                | sidenavOpen = not layoutModel.sidenavOpen
              }
            , Cmd.none
            )
