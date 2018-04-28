module Page.MyAdventurer.Update exposing (..)

import Http
import Request.QuestsRequest exposing (getQuestsByUser)
import Types exposing (Taco, RecentPostedQuest, TacoMsg(..))


type Msg
    = NoOp
    | GetQuestsByUserResult (Result Http.Error (List RecentPostedQuest))


type alias Model =
    { quests : List RecentPostedQuest
    }


initialModel =
    { quests = []
    }


onTacoMsg : TacoMsg -> ( Model, Taco ) -> ( Model, Cmd Msg )
onTacoMsg tacoMsg ( model, taco ) =
    case tacoMsg of
        MyAdventurerRoute ->
            let
                result =
                    Maybe.map
                        (\userId ->
                            getQuestsByUser taco.flags.apiEndpoint userId
                        )
                        taco.userId
            in
                case result of
                    Just request ->
                        ( model, Http.send GetQuestsByUserResult request )

                    Nothing ->
                        ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


onMsg : Msg -> ( Model, Taco ) -> ( Model, Cmd Msg )
onMsg msg ( model, taco ) =
    case msg of
        GetQuestsByUserResult (Result.Ok quests) ->
            ( { model | quests = quests }, Cmd.none )

        GetQuestsByUserResult (Result.Err _) ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
