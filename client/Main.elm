port module Main exposing (..)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Layout exposing (layout)
import Message exposing (Message, Message(..))
import Model exposing (Model, model)
import Navigation exposing (Location)
import Ports exposing (..)
import Update exposing (update)
import Update.RouteUpdate exposing (Route(..), parseLocation)
import View.MyAdventurerView exposing (myAdventurerView)
import View.QuestsView exposing (questsView)
import View.SideQuestsView exposing (sideQuestsView)
import View.CreateQuestView exposing (createQuestView)


view : Model -> Html Message
view model =
    layout model
        (case model.route of
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


subscriptions model =
    Sub.batch
        [ mount Mount
        , unmount Unmount
        , loadToken LoadToken
        , loadQuestStepImage LoadQuestStepImage
        ]


init : Location -> ( Model, Cmd Message )
init location =
    let
        initialLocation =
            parseLocation location
    in
        ( model initialLocation, Cmd.batch [ Navigation.modifyUrl location.href ] )


main : Program Never Model Message
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view >> toUnstyled
        , update = update
        , subscriptions = subscriptions
        }
