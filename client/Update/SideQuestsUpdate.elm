module Update.SideQuestsUpdate
    exposing
        ( onTacoMsg
        , onUpdate
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


onTacoMsg : TacoMsg -> ( SideQuestsModel, Taco ) -> ( SideQuestsModel, Cmd SideQuestsMsg )
onTacoMsg tacoMsg ( model, taco ) =
    case tacoMsg of
        SideQuestsRoute queryPath ->
            let
                params =
                    Array.fromList (String.split ":" queryPath)
            in
                ( { model
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
            ( model, Cmd.none )


onUpdate : SideQuestsMsg -> ( SideQuestsModel, Taco ) -> ( SideQuestsModel, Cmd SideQuestsMsg )
onUpdate message ( model, taco ) =
    case message of
        SuggestSideQuestResult (Result.Err _) ->
            ( { model
                | suggestingSideQuest = False
                , suggestSideQuestSuccess = Just False
              }
            , Cmd.none
            )

        SuggestSideQuestResult (Result.Ok success) ->
            ( { model
                | suggestingSideQuest = False
                , suggestSideQuestSuccess = Just True
              }
            , Cmd.none
            )

        GetSideQuestsResult (Result.Err _) ->
            ( { model
                | loading = False
              }
            , Cmd.none
            )

        GetSideQuestsResult (Result.Ok response) ->
            ( { model
                | sideQuestList = Just response.sideQuests
                , questInfo = Just response.quest
                , loading = False
              }
            , Cmd.none
            )

        ShowSideQuestForm ->
            ( { model
                | questFormOpen = True
                , sideQuestName = ""
                , sideQuestDescription = ""
              }
            , Cmd.none
            )

        HideSideQuestForm ->
            ( { model | questFormOpen = False }, Cmd.none )

        SubmitSideQuestForm ->
            ( { model
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
                                , name = model.sideQuestName
                                , description = model.sideQuestDescription
                                , suggestedBy = ""
                                , id = ""
                                }
                            )
                    )
                    model.questInfo
                    taco.token
                )
            )

        EditSideQuestName newName ->
            ( { model | sideQuestName = newName }, Cmd.none )

        EditSideQuestDescription newDescription ->
            ( { model | sideQuestDescription = newDescription }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
