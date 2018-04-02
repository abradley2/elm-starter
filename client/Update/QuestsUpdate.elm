module Update.QuestsUpdate
    exposing
        ( onTacoMsg
        , onUpdate
        , questsModel
        , QuestsModel
        , QuestsMsg
        )

import Request.QuestsRequest exposing (getQuests)
import Types exposing (Taco, RecentPostedQuest, TacoMsg, TacoMsg(..))
import Http


type QuestsMsg
    = NoOp
    | GetQuestsResult (Result Http.Error (List RecentPostedQuest))


type alias QuestsModel =
    { questList : List RecentPostedQuest
    }


questsModel : QuestsModel
questsModel =
    { questList = []
    }


onTacoMsg : TacoMsg -> ( QuestsModel, Taco ) -> ( QuestsModel, Cmd QuestsMsg )
onTacoMsg tacoMsg ( quests, taco ) =
    case tacoMsg of
        QuestsRoute ->
            let
                token =
                    Maybe.withDefault "" taco.token
            in
                ( quests
                , Http.send GetQuestsResult (getQuests taco.flags.apiEndpoint token)
                )

        _ ->
            ( quests, Cmd.none )


onUpdate : QuestsMsg -> ( QuestsModel, Taco ) -> ( QuestsModel, Cmd QuestsMsg )
onUpdate msg ( model, taco ) =
    case msg of
        GetQuestsResult (Result.Ok questList) ->
            ( { model | questList = questList }, Cmd.none )

        GetQuestsResult (Result.Err _) ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
