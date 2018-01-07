module Update.UserUpdate exposing (SessionModel, userUpdate, sessionModel)

import Message exposing (Message, Message(..))
import Message.SessionMessage exposing (SessionMessage, SessionMessage(..))
import Update.RouteUpdate exposing (parseLocation, Route, Route(..))
import Request.QuestsRequest exposing (getQuests)


type alias SessionModel =
    { token : Maybe String
    }


sessionModel : SessionModel
sessionModel =
    { token = Maybe.Nothing
    }


onUserMessage : SessionMessage -> SessionModel -> List (Cmd Message) -> ( SessionModel, List (Cmd Message) )
onUserMessage userMessage sessionModel commands =
    case userMessage of
        GetTokenResult (Result.Ok token) ->
            ( { sessionModel | token = Maybe.Just token }, commands )

        GetTokenResult (Result.Err _) ->
            ( sessionModel, commands )


onRouteChange : Route -> SessionModel -> List (Cmd Message) -> ( SessionModel, List (Cmd Message) )
onRouteChange newRoute sessionModel commands =
    case newRoute of
        ArmiesRoute ->
            let
                token =
                    Maybe.withDefault "" sessionModel.token
            in
                ( sessionModel
                , commands ++ [ Cmd.map Armies (getQuests token) ]
                )

        _ ->
            ( sessionModel, commands )


userUpdate : Message -> SessionModel -> List (Cmd Message) -> ( SessionModel, List (Cmd Message) )
userUpdate message sessionModel commands =
    case message of
        User userMessage ->
            onUserMessage userMessage sessionModel commands

        OnLocationChange location ->
            onRouteChange (parseLocation location) sessionModel commands

        _ ->
            ( sessionModel, commands )
