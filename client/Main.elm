port module Main exposing (..)

import Http
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Navigation exposing (Location)
import UrlParser exposing (..)
import Ports exposing (..)
import Util exposing (getReducerFactory, onTacoUpdate)


-- import requests

import Request.SessionRequest exposing (loadSession)


-- import views

import View.Layout exposing (layout)
import View.MyAdventurerView.Main exposing (myAdventurerView)
import View.QuestsView.Main exposing (questsView)
import View.CreateQuestView.Main exposing (createQuestView)
import View.QuestDetailsView.Main exposing (questDetailsView)


-- import updates

import Update.LayoutUpdate exposing (LayoutModel, layoutModel)
import Update.MyAdventurerUpdate exposing (MyAdventurerModel, myAdventurerInitialModel)
import Update.QuestsUpdate exposing (QuestsModel, questsModel)
import Update.QuestDetailsUpdate exposing (QuestDetailsModel, questDetailsInitialModel)
import Update.CreateQuestUpdate exposing (CreateQuestMsg(UploadQuestImageFinished), CreateQuestModel, createQuestInitialModel)
import Types exposing (Taco, TacoMsg, Flags, TacoMsg(..), RouteData, SessionInfo)


type alias Model =
    { taco : Taco
    , quests : QuestsModel
    , myAdventurer : MyAdventurerModel
    , layout : LayoutModel
    , createQuest : CreateQuestModel
    , questDetails : QuestDetailsModel
    }


model flags routeData =
    { taco =
        { flags = flags
        , token = Nothing
        , username = Nothing
        , userId = Nothing
        , routeData = routeData
        }
    , quests = questsModel
    , myAdventurer = myAdventurerInitialModel
    , layout = layoutModel
    , createQuest = createQuestInitialModel
    , questDetails = questDetailsInitialModel
    }


type Msg
    = Init
      -- session messages
    | LoadSessionResult (Result Http.Error SessionInfo)
    | OnLocationChange Location
      -- page messages
    | QuestsMsg Update.QuestsUpdate.QuestsMsg
    | LayoutMsg Update.LayoutUpdate.LayoutMsg
    | MyAdventurerMsg Update.MyAdventurerUpdate.MyAdventurerMsg
    | CreateQuestMsg Update.CreateQuestUpdate.CreateQuestMsg
    | QuestDetailsMsg Update.QuestDetailsUpdate.QuestDetailsMsg


matchers : Parser (TacoMsg -> a) a
matchers =
    oneOf
        [ UrlParser.map QuestsRoute (UrlParser.top)
        , UrlParser.map QuestsRoute (UrlParser.s "quests")
        , UrlParser.map QuestDetailsRoute (UrlParser.s "details" </> UrlParser.string)
        , UrlParser.map MyAdventurerRoute (UrlParser.s "profile")
        , UrlParser.map CreateQuestRoute (UrlParser.s "newquest")
        ]


parseLocation : Location -> RouteData
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            ( route, location )

        Nothing ->
            ( QuestsRoute, location )


tacoUpdate : Msg -> Taco -> ( Taco, TacoMsg, Cmd Msg )
tacoUpdate msg taco =
    case msg of
        Init ->
            let
                ( route, location ) =
                    taco.routeData
            in
                ( taco
                , route
                , Http.send LoadSessionResult
                    (loadSession
                        taco.flags.apiEndpoint
                        location.search
                    )
                )

        OnLocationChange location ->
            let
                ( route, _ ) =
                    parseLocation location
            in
                ( { taco | routeData = ( route, location ) }, route, Cmd.none )

        LoadSessionResult (Result.Ok tacoInfo) ->
            ( { taco
                | username = tacoInfo.username
                , userId = tacoInfo.userId
              }
            , TacoNoOp
            , let
                ( route, location ) =
                    taco.routeData
              in
                (Navigation.modifyUrl location.hash)
            )

        LoadSessionResult (Result.Err _) ->
            ( { taco
                | token = Nothing
                , username = Nothing
                , userId = Nothing
              }
            , TacoNoOp
            , Cmd.none
            )

        _ ->
            ( taco, TacoNoOp, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update message prevModel =
    let
        ( taco, tacoMsg, tacoCmd ) =
            tacoUpdate message prevModel.taco

        tacoUpdater =
            onTacoUpdate tacoMsg taco

        -- ALL our update functions should recieve the tacoMsg if there is one
        ( model, commands ) =
            ( { prevModel | taco = taco }, Cmd.none )
                |> tacoUpdater
                    (CreateQuestMsg)
                    (\model -> model.createQuest)
                    (\model createQuest -> { model | createQuest = createQuest })
                    (Update.CreateQuestUpdate.onTacoMsg tacoMsg)
                |> tacoUpdater
                    (QuestsMsg)
                    (\model -> model.quests)
                    (\model quests -> { model | quests = quests })
                    (Update.QuestsUpdate.onTacoMsg tacoMsg)
                |> tacoUpdater
                    (MyAdventurerMsg)
                    (\model -> model.myAdventurer)
                    (\model myAdventurer -> { model | myAdventurer = myAdventurer })
                    (Update.MyAdventurerUpdate.onTacoMsg tacoMsg)
                |> tacoUpdater
                    (QuestDetailsMsg)
                    (\model -> model.questDetails)
                    (\model questDetails -> { model | questDetails = questDetails })
                    (Update.QuestDetailsUpdate.onTacoMsg tacoMsg)

        updater =
            getReducerFactory model taco tacoCmd commands
    in
        case message of
            CreateQuestMsg msg ->
                updater
                    (CreateQuestMsg)
                    model.createQuest
                    (\model createQuest -> { model | createQuest = createQuest })
                    (Update.CreateQuestUpdate.onUpdate msg)

            QuestsMsg msg ->
                updater
                    (QuestsMsg)
                    model.quests
                    (\model quests -> { model | quests = quests })
                    (Update.QuestsUpdate.onUpdate msg)

            LayoutMsg msg ->
                updater
                    (LayoutMsg)
                    model.layout
                    (\model layout -> { model | layout = layout })
                    (Update.LayoutUpdate.onUpdate msg)

            MyAdventurerMsg msg ->
                updater
                    (MyAdventurerMsg)
                    model.myAdventurer
                    (\model myAdventurer -> { model | myAdventurer = myAdventurer })
                    (Update.MyAdventurerUpdate.onUpdate msg)

            QuestDetailsMsg msg ->
                updater
                    (QuestDetailsMsg)
                    model.questDetails
                    (\model questDetails -> { model | questDetails = questDetails })
                    (Update.QuestDetailsUpdate.onUpdate msg)

            _ ->
                ( model, Cmd.batch [ tacoCmd, commands ] )


view : Model -> Html Msg
view model =
    let
        ( route, location ) =
            model.taco.routeData
    in
        layout
            (LayoutMsg)
            model.layout
            model.taco
            (case route of
                QuestsRoute ->
                    Html.Styled.map QuestsMsg (questsView model.taco model.quests)

                QuestDetailsRoute params ->
                    Html.Styled.map QuestDetailsMsg (questDetailsView model.taco model.questDetails)

                MyAdventurerRoute ->
                    Html.Styled.map MyAdventurerMsg (myAdventurerView model.taco model.myAdventurer)

                CreateQuestRoute ->
                    Html.Styled.map CreateQuestMsg (createQuestView model.taco model.createQuest)

                _ ->
                    div [] [ h4 [] [ text "NOT FOUND" ] ]
            )


subscriptions model =
    Sub.batch
        [ Sub.map CreateQuestMsg (uploadQuestImageFinished UploadQuestImageFinished)
        ]


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        initialLocation =
            parseLocation location

        ( initialModel, initialCmd ) =
            update Init (model flags initialLocation)
    in
        ( initialModel, initialCmd )


main : Program Flags Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view >> toUnstyled
        , update = update
        , subscriptions = subscriptions
        }
