module Page.Quests.Update exposing (..)

import Http
import Request.QuestsRequest exposing (getQuests)
import Types exposing (Taco, RecentPostedQuest, TacoMsg, TacoMsg(..))


type Msg
    = NoOp
    | GetQuestsResult (Result Http.Error (List RecentPostedQuest))


type alias Model =
    { questList : List RecentPostedQuest
    }


initialModel : Model
initialModel =
    { questList = []
    }


onTacoMsg : TacoMsg -> ( Model, Taco ) -> ( Model, Cmd Msg )
onTacoMsg tacoMsg ( quests, taco ) =
    case tacoMsg of
        QuestsRoute ->
            ( quests
            , Http.send GetQuestsResult (getQuests taco.flags.apiEndpoint)
            )

        _ ->
            ( quests, Cmd.none )


onMsg : Msg -> ( Model, Taco ) -> ( Model, Cmd Msg )
onMsg msg ( model, taco ) =
    case msg of
        GetQuestsResult (Result.Ok questList) ->
            ( { model | questList = questList }, Cmd.none )

        GetQuestsResult (Result.Err _) ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
