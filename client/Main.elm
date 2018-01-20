port module Main exposing (..)

import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Layout exposing (layout)
import Message exposing (Message, Message(..))
import Model exposing (Model, model)
import Navigation exposing (Location)
import Update exposing (update)
import Update.RouteUpdate exposing (Route(..), parseLocation)
import View.QuestsView exposing (questsView)
import View.SideQuestsView exposing (sideQuestsView)


port mount : (( String, String ) -> message) -> Sub message


port unmount : (( String, String ) -> message) -> Sub message


port loadToken : (String -> message) -> Sub message


view : Model -> Html Message
view model =
    layout model
        (case model.route of
            QuestsRoute ->
                Html.Styled.map Quests (questsView model)

            SideQuestsRoute ->
                Html.Styled.map SideQuests (sideQuestsView model)

            NotFoundRoute ->
                Html.Styled.map Quests (questsView model)
        )


subscriptions model =
    Sub.batch
        [ mount Mount
        , unmount Unmount
        , loadToken LoadToken
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
