module Update.HomeUpdate exposing (homeModel, homeUpdate)

import Message exposing (Message, Message(..))
import Message.HomeMessage exposing (HomeMessage(..))


type alias HomeModel =
    { greeting : String
    }


homeModel : HomeModel
homeModel =
    { greeting = "Hello World again"
    }


onHomeMessage : HomeMessage -> HomeModel -> ( HomeModel, List (Cmd Message) )
onHomeMessage homeMessage homeModel =
    case homeMessage of
        EditGreeting newGreeting ->
            ( { homeModel
                | greeting = newGreeting
              }
            , []
            )

        NoOp ->
            ( homeModel, [] )


homeUpdate : Message -> HomeModel -> ( HomeModel, List (Cmd Message) )
homeUpdate message homeModel =
    case message of
        HomeMessage ->
            onHomeMessage message homeModel

        _ ->
            ( homeModel, [] )
