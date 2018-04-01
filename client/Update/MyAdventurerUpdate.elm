module Update.MyAdventurerUpdate
    exposing
        ( myAdventurerUpdate
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


myAdventurerUpdate : MyAdventurerMsg -> TacoMsg -> MyAdventurerModel -> Taco -> ( MyAdventurerModel, Cmd MyAdventurerMsg )
myAdventurerUpdate msg tacoMsg model taco =
    let
        ( myAdventurer, command ) =
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
    in
        case msg of
            GetQuestsByUserResult (Result.Ok quests) ->
                ( { myAdventurer | quests = quests }, command )

            GetQuestsByUserResult (Result.Err _) ->
                ( myAdventurer, command )

            NoOp ->
                ( myAdventurer, command )
