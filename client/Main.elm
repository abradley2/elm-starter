port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation exposing (Location)
import Message exposing (Message, Message(..))
import Model exposing (Model, model)
import Update exposing (update)
import Update.RouteUpdate exposing (parseLocation, RouteModel(..))
import View.HomeView exposing (homeView)
import View.AboutView exposing (aboutView)


view : Model -> Html Message
view model =
    case model.routeModel of
        HomeRoute ->
            Html.map Home (homeView model)

        AboutRoute ->
            Html.map About (aboutView model)

        NotFoundRoute ->
            notFound


notFound : Html Message
notFound =
    div [ class "center measure" ]
        [ h3 [] [ text "Page Not Found :(" ]
        ]


subscriptions model =
    Sub.none


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
