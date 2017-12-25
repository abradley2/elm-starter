port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Message exposing (Message, Message(..))
import Model exposing (Model, model)
import Navigation exposing (Location)
import Update exposing (update)
import Update.RouteUpdate exposing (RouteModel(..), parseLocation)
import View.AboutView exposing (aboutView)
import View.HomeView exposing (homeView)


port mount : (String -> message) -> Sub message


port unmount : (String -> message) -> Sub message


view : Model -> Html Message
view model =
    case model.routeModel of
        HomeRoute ->
            Html.map Home (homeView model)

        AboutRoute ->
            Html.map About (aboutView model)

        NotFoundRoute ->
            div [ class "center measure" ]
                [ h3 [] [ text "Page Not Found :(" ]
                ]


subscriptions model =
    mount Mount


init : Location -> ( Model, Cmd Message )
init location =
    let
        ( initialLocation, commands ) =
            parseLocation location []
    in
        ( model initialLocation, Cmd.batch commands )


main : Program Never Model Message
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
