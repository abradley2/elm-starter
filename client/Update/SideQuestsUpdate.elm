module Update.SideQuestsUpdate
    exposing
        ( onUpdate
        , sideQuestsModel
        , SideQuestsModel
        , SideQuestsMsg
        , SideQuestsMsg(..)
        )

import UrlParser exposing (..)
import Types exposing (Taco, TacoMsg, TacoMsg(..), SideQuest, GetSideQuestsResponse, RecentPostedQuest)
import Request.QuestsRequest exposing (getSideQuests, suggestSideQuest)
import Array
import Http


type SideQuestsMsg
    = GetSideQuestsResult (Result Http.Error GetSideQuestsResponse)
    | ShowSideQuestForm
    | HideSideQuestForm
    | SubmitSideQuestForm
    | SuggestSideQuestResult (Result Http.Error Bool)
    | EditSideQuestName String
    | EditSideQuestDescription String
    | NoOp


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


handleTacoMsg : TacoMsg -> SideQuestsModel -> Taco -> ( SideQuestsModel, Cmd SideQuestsMsg )
handleTacoMsg tacoMsg sideQuests taco =
    case tacoMsg of
        SideQuestsRoute queryPath ->
            let
                params =
                    Array.fromList (String.split ":" queryPath)
            in
                ( { sideQuestsModel
                    | loading = True
                    , questInfo = Nothing
                    , sideQuestList = Nothing
                  }
                , Http.send GetSideQuestsResult
                    (getSideQuests
                        taco.flags.apiEndpoint
                        (Maybe.withDefault "" taco.token)
                        (Maybe.withDefault "" (Array.get 0 params))
                        (Maybe.withDefault "" (Array.get 1 params))
                    )
                )

        _ ->
            ( sideQuests, Cmd.none )


onUpdate : SideQuestsMsg -> TacoMsg -> SideQuestsModel -> Taco -> ( SideQuestsModel, Cmd SideQuestsMsg )
onUpdate message tacoMsg model taco =
    let
        ( sideQuests, commands ) =
            handleTacoMsg tacoMsg model taco
    in
        case message of
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
                , Maybe.withDefault Cmd.none
                    (Maybe.map2
                        (\quest userId ->
                            Http.send SuggestSideQuestResult
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
                        )
                        sideQuests.questInfo
                        taco.token
                    )
                )

            EditSideQuestName newName ->
                ( { sideQuests | sideQuestName = newName }, commands )

            EditSideQuestDescription newDescription ->
                ( { sideQuests | sideQuestDescription = newDescription }, commands )

            NoOp ->
                ( sideQuests, commands )
