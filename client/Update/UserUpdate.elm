module Update.UserUpdate exposing (UserModel, userUpdate, userModel)

import Message exposing (Message, Message(..))
import Message.UserMessage exposing (UserMessage, UserMessage(..))


type alias UserModel =
    { token : Maybe String
    }


userModel : UserModel
userModel =
    { token = Maybe.Nothing
    }


onUserMessage : UserMessage -> UserModel -> List (Cmd Message) -> ( UserModel, List (Cmd Message) )
onUserMessage userMessage userModel commands =
    case userMessage of
        GetTokenResult (Result.Ok token) ->
            ( { userModel | token = Maybe.Just token }, commands )

        GetTokenResult (Result.Err _) ->
            ( userModel, commands )


userUpdate : Message -> UserModel -> List (Cmd Message) -> ( UserModel, List (Cmd Message) )
userUpdate message userModel commands =
    case message of
        User userMessage ->
            onUserMessage userMessage userModel commands

        _ ->
            ( userModel, commands )
