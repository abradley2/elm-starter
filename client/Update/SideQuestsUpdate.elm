module Update.SideQuestsUpdate exposing (SideQuestsModel, sideQuestsUpdate, sideQuestsModel)

import Msg exposing (Msg, Msg(..))
import Msg.SideQuestsMsg exposing (SideQuestsMsg, SideQuestsMsg(..))
import UrlParser exposing (..)
import Types exposing (Taco, SideQuest, GetSideQuestsResponse, RecentPostedQuest)
import Request.QuestsRequest exposing (getSideQuests, suggestSideQuest)
import Array


type alias SideQuestsModel =
    { questInfo : Maybe RecentPostedQuest
    , loading : Bool
    , sideQuestList : Maybe (List SideQuest)
    , questFormOpen : Bool
    , sideQuestName : String
    , sideQuestDescription : String
    , suggestingSideQuest : Bool
    , suggestSideQuestSuccess : Maybe Bool
    }


sideQuestsModel : SideQuestsModel
sideQuestsModel =
    { questFormOpen = False
    , questInfo = Nothing
    , loading = False
    , sideQuestList = Nothing
    , sideQuestName = ""
    , sideQuestDescription = ""
    , suggestingSideQuest = False
    , suggestSideQuestSuccess = Nothing
    }


onSideQuestsMsg : SideQuestsMsg -> ( Taco, SideQuestsModel ) -> List (Cmd Msg) -> ( SideQuestsModel, List (Cmd Msg) )
onSideQuestsMsg sideQuestsMsg ( taco, sideQuests ) commands =
    case sideQuestsMsg of
        SuggestSideQuestResult (Result.Err _) ->
            ( { sideQuests
                | suggestingSideQuest = False
                , suggestSideQuestSuccess = Just False
              }
            , commands
            )

        SuggestSideQuestResult (Result.Ok success) ->
            ( { sideQuests
                | suggestingSideQuest = False
                , suggestSideQuestSuccess = Just True
              }
            , commands
            )

        GetSideQuestsResult (Result.Err _) ->
            ( { sideQuests
                | loading = False
              }
            , commands
            )

        GetSideQuestsResult (Result.Ok response) ->
            ( { sideQuests
                | sideQuestList = Just response.sideQuests
                , questInfo = Just response.quest
                , loading = False
              }
            , commands
            )

        ShowSideQuestForm ->
            ( { sideQuests
                | questFormOpen = True
                , sideQuestName = ""
                , sideQuestDescription = ""
              }
            , commands
            )

        HideSideQuestForm ->
            ( { sideQuests | questFormOpen = False }, commands )

        SubmitSideQuestForm ->
            ( { sideQuests
                | questFormOpen = False
                , suggestingSideQuest = True
              }
            , (commands
                ++ (let
                        result =
                            Maybe.map2
                                (\quest userId ->
                                    [ Cmd.map SideQuests
                                        (suggestSideQuest
                                            taco.flags.apiEndpoint
                                            userId
                                            quest
                                            { guid = ""
                                            , name = sideQuests.sideQuestName
                                            , description = sideQuests.sideQuestDescription
                                            , suggestedBy = ""
                                            , id = ""
                                            }
                                        )
                                    ]
                                )
                                sideQuests.questInfo
                                taco.token
                    in
                        Maybe.withDefault [] result
                   )
              )
            )

        EditSideQuestName newName ->
            ( { sideQuests | sideQuestName = newName }, commands )

        EditSideQuestDescription newDescription ->
            ( { sideQuests | sideQuestDescription = newDescription }, commands )

        NoOp ->
            ( sideQuests, commands )


sideQuestsUpdate : Msg -> ( Taco, SideQuestsModel ) -> List (Cmd Msg) -> ( SideQuestsModel, List (Cmd Msg) )
sideQuestsUpdate msg ( taco, sideQuests ) commands =
    case msg of
        SideQuests sideQuestsMsg ->
            onSideQuestsMsg sideQuestsMsg ( taco, sideQuests ) commands

        OnLocationChange location ->
            case parseHash (s "sidequests" </> string) location of
                Just queryPath ->
                    let
                        params =
                            Array.fromList (String.split ":" queryPath)
                    in
                        ( { sideQuestsModel
                            | loading = True
                            , questInfo = Nothing
                            , sideQuestList = Nothing
                          }
                        , commands
                            ++ [ Cmd.map SideQuests
                                    (getSideQuests
                                        taco.flags.apiEndpoint
                                        (Maybe.withDefault "" taco.token)
                                        (Maybe.withDefault "" (Array.get 0 params))
                                        (Maybe.withDefault "" (Array.get 1 params))
                                    )
                               ]
                        )

                Nothing ->
                    ( sideQuests, commands )

        _ ->
            ( sideQuests, commands )
