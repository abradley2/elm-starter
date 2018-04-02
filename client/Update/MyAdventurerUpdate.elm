module Update.MyAdventurerUpdate
    exposing
        ( onUpdate
        , onTacoMsg
        , myAdventurerInitialModel
        , MyAdventurerModel
        , MyAdventurerMsg
        , MyAdventurerMsg(..)
        )

import Request.QuestsRequest exposing (getQuestsByUser)
import Types exposing (Taco, RecentPostedQuest, TacoMsg(..))
import Http


type MyAdventurerMsg
    = NoOp
    | GetQuestsByUserResult (Result Http.Error (List RecentPostedQuest))


type alias MyAdventurerModel =
    { quests : List RecentPostedQuest
    }


myAdventurerInitialModel =
    { quests = []
    }


onTacoMsg : TacoMsg -> ( MyAdventurerModel, Taco ) -> ( MyAdventurerModel, Cmd MyAdventurerMsg )
onTacoMsg tacoMsg ( model, taco ) =
    case tacoMsg of
        MyAdventurerRoute ->
            let
                result =
                    Maybe.map2
                        (\userId token ->
                            getQuestsByUser taco.flags.apiEndpoint token userId
                        )
                        taco.userId
                        taco.token
            in
                case result of
                    Just request ->
                        ( model, Http.send GetQuestsByUserResult request )

                    Nothing ->
                        ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


onUpdate : MyAdventurerMsg -> ( MyAdventurerModel, Taco ) -> ( MyAdventurerModel, Cmd MyAdventurerMsg )
onUpdate msg ( model, taco ) =
    case msg of
        GetQuestsByUserResult (Result.Ok quests) ->
            ( { model | quests = quests }, Cmd.none )

        GetQuestsByUserResult (Result.Err _) ->
            ( model, Cmd.none )

        NoOp ->
            ( model, Cmd.none )
