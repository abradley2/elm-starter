port module Main exposing (..)

import Http
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Navigation exposing (Location)
import UrlParser exposing (..)
import Ports exposing (..)


-- import requests

import Request.SessionRequest exposing (loadSession)


-- import views

import View.Layout exposing (layout)
import View.MyAdventurerView.Main exposing (myAdventurerView)
import View.QuestsView.Main exposing (questsView)
import View.SideQuestsView.Main exposing (sideQuestsView)
import View.CreateQuestView.Main exposing (createQuestView)
import View.QuestDetailsView.Main exposing (questDetailsView)


-- import updates

import Update.LayoutUpdate exposing (LayoutModel, layoutModel)
import Update.MyAdventurerUpdate exposing (MyAdventurerModel, myAdventurerInitialModel)
import Update.QuestsUpdate exposing (QuestsModel, questsModel)
import Update.SideQuestsUpdate exposing (SideQuestsModel, sideQuestsModel)
import Update.QuestDetailsUpdate exposing (QuestDetailsModel, questDetailsInitialModel)
import Update.CreateQuestUpdate exposing (CreateQuestMsg(UploadQuestImageFinished), CreateQuestModel, createQuestInitialModel)
import Types exposing (Taco, TacoMsg, Flags, TacoMsg(..), RouteData, SessionInfo)


type alias Model =
    { taco : Taco
    , quests : QuestsModel
    , myAdventurer : MyAdventurerModel
    , sideQuests : SideQuestsModel
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
    , sideQuests = sideQuestsModel
    , layout = layoutModel
    , createQuest = createQuestInitialModel
    , questDetails = questDetailsInitialModel
    }


type Msg
    = Init
      -- session messages
    | LoadToken String
    | GetTokenResult (Result Http.Error String)
    | LoadSessionResult (Result Http.Error SessionInfo)
    | OnLocationChange Location
      -- page messages
    | QuestsMsg Update.QuestsUpdate.QuestsMsg
    | SideQuestsMsg Update.SideQuestsUpdate.SideQuestsMsg
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
        , UrlParser.map SideQuestsRoute (UrlParser.s "sidequests" </> UrlParser.string)
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
                ( taco, route, Cmd.none )

        OnLocationChange location ->
            let
                ( route, _ ) =
                    parseLocation location
            in
                ( { taco | routeData = ( route, location ) }, route, Cmd.none )

        LoadToken token ->
            ( { taco | token = Just token }
            , TacoNoOp
            , Http.send LoadSessionResult (loadSession taco.flags.apiEndpoint token)
            )

        GetTokenResult (Result.Ok token) ->
            ( { taco | token = Just token }, TacoNoOp, Cmd.none )

        GetTokenResult (Result.Err _) ->
            ( { taco
                | token = Nothing
                , username = Nothing
                , userId = Nothing
              }
            , TacoNoOp
            , Cmd.none
            )

        LoadSessionResult (Result.Ok tacoInfo) ->
            ( { taco
                | username = Just tacoInfo.username
                , userId = Just tacoInfo.userId
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
update message model =
    let
        ( taco, tacoMsg, tacoCmd ) =
            tacoUpdate message model.taco

        updater =
            (\messageType pageModel setter reducer ->
                let
                    ( updatedPageModel, cmd ) =
                        reducer ( pageModel, taco )
                in
                    ( setter model updatedPageModel, Cmd.batch [ tacoCmd, Cmd.map messageType cmd ] )
            )
    in
        case (Debug.log "got message" message) of
            CreateQuestMsg msg ->
                updater
                    (CreateQuestMsg)
                    model.createQuest
                    (\model createQuest -> { model | createQuest = createQuest })
                    (Update.CreateQuestUpdate.onUpdate msg)

            SideQuestsMsg msg ->
                updater
                    (SideQuestsMsg)
                    model.sideQuests
                    (\model sideQuests -> { model | sideQuests = sideQuests })
                    (Update.SideQuestsUpdate.onUpdate msg)

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
                ( model, tacoCmd )


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

                SideQuestsRoute params ->
                    Html.Styled.map SideQuestsMsg (sideQuestsView model.taco model.sideQuests)

                MyAdventurerRoute ->
                    Html.Styled.map MyAdventurerMsg (myAdventurerView model.taco model.myAdventurer)

                CreateQuestRoute ->
                    Html.Styled.map CreateQuestMsg (createQuestView model.taco model.createQuest)

                _ ->
                    Html.Styled.map QuestsMsg (questsView model.taco model.quests)
            )


subscriptions model =
    Sub.batch
        [ loadToken LoadToken
        , Sub.map CreateQuestMsg (uploadQuestImageFinished UploadQuestImageFinished)
        ]


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        initialLocation =
            parseLocation location

        ( initialModel, initialCmd ) =
            update Init (model flags initialLocation)
    in
        ( initialModel, Cmd.batch [ initialCmd, Navigation.modifyUrl location.href ] )


main : Program Flags Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view >> toUnstyled
        , update = update
        , subscriptions = subscriptions
        }
