port module Main exposing (..)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Layout exposing (layout)
import Msg exposing (Msg, Msg(..))
import Model exposing (Model, model)
import Navigation exposing (Location)
import Ports exposing (..)
import Types exposing (Flags, Route(..))
import Update exposing (update)
import Update.RouteUpdate exposing (parseLocation)
import View.MyAdventurerView.Main exposing (myAdventurerView)
import View.QuestsView.Main exposing (questsView)
import View.SideQuestsView.Main exposing (sideQuestsView)
import View.CreateQuestView.Main exposing (createQuestView)
import View.QuestDetailsView.Main exposing (questDetailsView)


view : Model -> Html Msg
view model =
    let
        ( route, location ) =
            model.routeData
    in
        layout model
            (case route of
                QuestsRoute ->
                    Html.Styled.map Quests (questsView model)

                QuestDetailsRoute params ->
                    Html.Styled.map QuestDetails (questDetailsView model)

                SideQuestsRoute params ->
                    Html.Styled.map SideQuests (sideQuestsView model)

                MyAdventurerRoute ->
                    Html.Styled.map MyAdventurer (myAdventurerView model)

                CreateQuestRoute ->
                    Html.Styled.map CreateQuest (createQuestView model)

                NotFoundRoute ->
                    Html.Styled.map Quests (questsView model)
            )



{- TODO: use Cmd.map for the bottom 3 -}


subscriptions model =
    Sub.batch
        [ mount Mount
        , unmount Unmount
        , loadToken LoadToken
        , loadQuestId LoadQuestId
        , uploadQuestImageFinished UploadQuestImageFinished
        ]


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        initialLocation =
            parseLocation location
    in
        ( model flags initialLocation, Cmd.batch [ Navigation.modifyUrl location.href ] )


main : Program Flags Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view >> toUnstyled
        , update = update
        , subscriptions = subscriptions
        }
