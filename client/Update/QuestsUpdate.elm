module Update.QuestsUpdate exposing (questsModel, questsUpdate, QuestsModel, QuestsMsg)

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


handleTacoMsg tacoMsg quests taco =
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


questsUpdate : QuestsMsg -> TacoMsg -> QuestsModel -> Taco -> ( QuestsModel, Cmd QuestsMsg )
questsUpdate msg tacoMsg model taco =
    let
        ( quests, commands ) =
            handleTacoMsg (Debug.log "got taco msg" tacoMsg) model taco
    in
        case msg of
            GetQuestsResult (Result.Ok questList) ->
                ( { quests | questList = questList }, commands )

            GetQuestsResult (Result.Err _) ->
                ( quests, commands )

            NoOp ->
                ( quests, commands )
