port module Main exposing (..)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Layout exposing (layout)
import Message exposing (Message, Message(..))
import Model exposing (Model, model)
import Navigation exposing (Location)
import Ports exposing (..)
import Types exposing (Flags)
import Update exposing (update)
import Update.RouteUpdate exposing (Route(..), parseLocation)
import View.MyAdventurerView exposing (myAdventurerView)
import View.QuestsView exposing (questsView)
import View.SideQuestsView exposing (sideQuestsView)
import View.CreateQuestView exposing (createQuestView)


view : Model -> Html Message
view model =
    let
        ( route, location ) =
            model.routeData
    in
        layout model
            (case route of
                QuestsRoute ->
                    Html.Styled.map Quests (questsView model)

                SideQuestsRoute ->
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


init : Flags -> Location -> ( Model, Cmd Message )
init flags location =
    let
        initialLocation =
            parseLocation location
    in
        ( model flags initialLocation, Cmd.batch [ Navigation.modifyUrl location.href ] )


main : Program Flags Model Message
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view >> toUnstyled
        , update = update
        , subscriptions = subscriptions
        }
