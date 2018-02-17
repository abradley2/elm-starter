module Update.SideQuestsUpdate exposing (SideQuestsModel, sideQuestsUpdate, sideQuestsModel)

import Message exposing (Message, Message(..))
import Message.SideQuestsMessage exposing (SideQuestsMessage, SideQuestsMessage(..))
import UrlParser exposing (..)
import Types exposing (SessionModel, SideQuest)
import Request.QuestsRequest exposing (getSideQuests)
import Array


type alias SideQuestsModel =
    { questId : String
    , loading : Bool
    , sideQuestList : List SideQuest
    }


sideQuestsModel : SideQuestsModel
sideQuestsModel =
    { questId = ""
    , loading = False
    , sideQuestList = []
    }


onSideQuestsMessage : SideQuestsMessage -> SideQuestsModel -> List (Cmd Message) -> ( SideQuestsModel, List (Cmd Message) )
onSideQuestsMessage sideQuestsMessage sideQuests commands =
    case sideQuestsMessage of
        AddNewSideQuest ->
            ( sideQuests, commands )

        GetSideQuestsResult (Result.Err _) ->
            ( { sideQuests
                | loading = False
              }
            , commands
            )

        GetSideQuestsResult (Result.Ok sideQuestList) ->
            ( { sideQuests
                | sideQuestList = sideQuestList
                , loading = False
              }
            , commands
            )


sideQuestsUpdate : Message -> ( SessionModel, SideQuestsModel ) -> List (Cmd Message) -> ( SideQuestsModel, List (Cmd Message) )
sideQuestsUpdate message ( session, sideQuests ) commands =
    case message of
        SideQuests sideQuestsMessage ->
            onSideQuestsMessage sideQuestsMessage sideQuests commands

        OnLocationChange location ->
            case parseHash (s "sidequests" </> string) location of
                Just queryPath ->
                    let
                        params =
                            Array.fromList (String.split ":" queryPath)
                    in
                        ( { sideQuests
                            | questId = Maybe.withDefault "" (Array.get 1 params)
                            , loading = True
                          }
                        , commands
                            ++ [ Cmd.map SideQuests
                                    (getSideQuests
                                        session.flags.apiEndpoint
                                        (Maybe.withDefault "" session.token)
                                        (Maybe.withDefault "" (Array.get 0 params))
                                        (Maybe.withDefault "" (Array.get 1 params))
                                    )
                               ]
                        )

                Nothing ->
                    ( sideQuests, commands )

        _ ->
            ( sideQuests, commands )
