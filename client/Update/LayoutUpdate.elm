module Update.LayoutUpdate exposing (layoutUpdate, layoutModel, LayoutModel)

import Message exposing (Message, Message(..))
import Message.LayoutMessage exposing (LayoutMessage, LayoutMessage(..))


type alias LayoutModel =
    { sidenavOpen : Bool
    }


layoutModel =
    { sidenavOpen = False
    }


onLayoutMessage : LayoutMessage -> LayoutModel -> List (Cmd Message) -> ( LayoutModel, List (Cmd Message) )
onLayoutMessage layoutMessage layoutModel commands =
    case layoutMessage of
        ToggleSidenav ->
            ( { layoutModel
                | sidenavOpen = not layoutModel.sidenavOpen
              }
            , commands
            )


layoutUpdate : Message -> LayoutModel -> List (Cmd Message) -> ( LayoutModel, List (Cmd Message) )
layoutUpdate message layoutModel commands =
    case message of
        Layout layoutMessage ->
            onLayoutMessage layoutMessage layoutModel commands

        _ ->
            ( layoutModel, commands )
