module Update.HomeUpdate exposing (homeModel, homeUpdate, HomeModel)

import Message exposing (Message, Message(..))
import Message.HomeMessage exposing (HomeMessage(..))


type alias HomeModel =
    { greeting : String
    }


homeModel : HomeModel
homeModel =
    { greeting = "Hello World again"
    }


onHomeMessage : HomeMessage -> HomeModel -> List (Cmd Message) -> ( HomeModel, List (Cmd Message) )
onHomeMessage homeMessage homeModel commands =
    case homeMessage of
        EditGreeting newGreeting ->
            ( { homeModel
                | greeting = newGreeting
              }
            , commands
            )

        NoOp ->
            ( homeModel, commands )


homeUpdate : Message -> HomeModel -> List (Cmd Message) -> ( HomeModel, List (Cmd Message) )
homeUpdate message homeModel commands =
    case message of
        Home homeMessage ->
            onHomeMessage homeMessage homeModel commands

        _ ->
            ( homeModel, commands )
