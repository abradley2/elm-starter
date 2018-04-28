port module Main exposing (..)

import Http
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Navigation exposing (Location)
import UrlParser exposing (..)
import Ports exposing (..)
import Util exposing (getReducerFactory, onTacoUpdate)
import Request.SessionRequest exposing (loadSession)
import Types exposing (Taco, TacoMsg, Flags, TacoMsg(..), RouteData, SessionInfo)


-- import updaters

import Page.CreateQuest.Update as CreateQuestUpdate exposing (Msg(UploadQuestImageFinished))
import Page.MyAdventurer.Update as MyAdventurerUpdate
import Page.QuestDetails.Update as QuestDetailsUpdate
import Page.Quests.Update as QuestsUpdate


-- import views

import Page.Layout as Layout
import Page.MyAdventurer.View as MyAdventurerView
import Page.Quests.View as QuestsView
import Page.CreateQuest.View as CreateQuestView
import Page.QuestDetails.View as QuestDetailsView


type alias Model =
    { taco : Taco
    , quests : QuestsUpdate.Model
    , myAdventurer : MyAdventurerUpdate.Model
    , layout : Layout.Model
    , createQuest : CreateQuestUpdate.Model
    , questDetails : QuestDetailsUpdate.Model
    }


model flags routeData =
    { taco =
        { flags = flags
        , username = Nothing
        , userId = Nothing
        , routeData = routeData
        }
    , quests = QuestsUpdate.initialModel
    , myAdventurer = MyAdventurerUpdate.initialModel
    , layout = Layout.initialModel
    , createQuest = CreateQuestUpdate.initialModel
    , questDetails = QuestDetailsUpdate.initialModel
    }


type Msg
    = Init
      -- session messages
    | LoadSessionResult (Result Http.Error SessionInfo)
    | Navigate String
    | OnLocationChange Location
      -- page messages
    | QuestsMsg QuestsUpdate.Msg
    | LayoutMsg Layout.Msg
    | MyAdventurerMsg MyAdventurerUpdate.Msg
    | CreateQuestMsg CreateQuestUpdate.Msg
    | QuestDetailsMsg QuestDetailsUpdate.Msg


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
    case (parsePath matchers location) of
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

        Navigate newUrl ->
            ( taco, TacoNoOp, Navigation.newUrl newUrl )

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
                (Navigation.modifyUrl location.pathname)
            )

        LoadSessionResult (Result.Err _) ->
            let
                ( route, location ) =
                    taco.routeData
            in
                ( { taco
                    | username = Nothing
                    , userId = Nothing
                  }
                , TacoNoOp
                , (Navigation.modifyUrl location.pathname)
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
                    (CreateQuestUpdate.onTacoMsg tacoMsg)
                |> tacoUpdater
                    (QuestsMsg)
                    (\model -> model.quests)
                    (\model quests -> { model | quests = quests })
                    (QuestsUpdate.onTacoMsg tacoMsg)
                |> tacoUpdater
                    (MyAdventurerMsg)
                    (\model -> model.myAdventurer)
                    (\model myAdventurer -> { model | myAdventurer = myAdventurer })
                    (MyAdventurerUpdate.onTacoMsg tacoMsg)
                |> tacoUpdater
                    (QuestDetailsMsg)
                    (\model -> model.questDetails)
                    (\model questDetails -> { model | questDetails = questDetails })
                    (QuestDetailsUpdate.onTacoMsg tacoMsg)

        updater =
            getReducerFactory model taco tacoCmd commands
    in
        case message of
            CreateQuestMsg msg ->
                updater
                    (CreateQuestMsg)
                    model.createQuest
                    (\model createQuest -> { model | createQuest = createQuest })
                    (CreateQuestUpdate.onMsg msg)

            QuestsMsg msg ->
                updater
                    (QuestsMsg)
                    model.quests
                    (\model quests -> { model | quests = quests })
                    (QuestsUpdate.onMsg msg)

            LayoutMsg msg ->
                updater
                    (LayoutMsg)
                    model.layout
                    (\model layout -> { model | layout = layout })
                    (Layout.onMsg msg)

            MyAdventurerMsg msg ->
                updater
                    (MyAdventurerMsg)
                    model.myAdventurer
                    (\model myAdventurer -> { model | myAdventurer = myAdventurer })
                    (MyAdventurerUpdate.onMsg msg)

            QuestDetailsMsg msg ->
                updater
                    (QuestDetailsMsg)
                    model.questDetails
                    (\model questDetails -> { model | questDetails = questDetails })
                    (QuestDetailsUpdate.onMsg msg)

            _ ->
                ( model, Cmd.batch [ tacoCmd, commands ] )


view : Model -> Html Msg
view model =
    let
        ( route, location ) =
            model.taco.routeData
    in
        Layout.render
            (LayoutMsg)
            model.layout
            model.taco
            (case route of
                QuestsRoute ->
                    Html.Styled.map QuestsMsg (QuestsView.render model.taco model.quests)

                QuestDetailsRoute params ->
                    Html.Styled.map QuestDetailsMsg (QuestDetailsView.render model.taco model.questDetails)

                MyAdventurerRoute ->
                    Html.Styled.map MyAdventurerMsg (MyAdventurerView.render model.taco model.myAdventurer)

                CreateQuestRoute ->
                    Html.Styled.map CreateQuestMsg (CreateQuestView.render model.taco model.createQuest)

                _ ->
                    div [] [ h4 [] [ text "NOT FOUND" ] ]
            )


subscriptions model =
    Sub.batch
        [ Sub.map CreateQuestMsg (uploadQuestImageFinished UploadQuestImageFinished)
        , navigate Navigate
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
