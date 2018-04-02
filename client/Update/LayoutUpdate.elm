module Update.LayoutUpdate
    exposing
        ( onUpdate
        , onTacoUpdate
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


onTacoUpdate tacoMsg ( model, taco ) =
    ( model, Cmd.none )


onUpdate : LayoutMsg -> ( LayoutModel, Taco ) -> ( LayoutModel, Cmd LayoutMsg )
onUpdate msg ( model, taco ) =
    case msg of
        ToggleSidenav ->
            ( { model
                | sidenavOpen = not model.sidenavOpen
              }
            , Cmd.none
            )
