port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation exposing (Location)
import Routing exposing (Route, parseLocation)
import Message exposing (Message)
import Model exposing (Model)
import Update.HomeUpdate exposing (homeUpdate)
import Update.AboutUpdate exposing (homeUpdate)
import View.HomeView exposing (homeModel)
import View.AboutView exposing (aboutView)


initialModel route =
    { route = route
    , home = aboutModel
    , about = homeModel
    }


update message model =
    case message of
        OnLocationChange location ->
            let
                newLocation =
                    location
            in
                ( { model | route = parseLocation newLocation }, Cmd.none )

        _ ->
            let
                ( updatedModel, commands ) =
                    ( model, [] )
                        |> (\( model, commands ) ->
                                let
                                    ( homeModel, commands ) =
                                        homeUpdate message model.homeModel
                                in
                                    ( { model | homeModel = homeModel }
                                    , commands
                                    )
                           )
                        |> (\( model, commands ) ->
                                let
                                    ( aboutModel, batch ) =
                                        aboutUpdate message model.aboutModel
                                in
                                    ( { model | aboutModel = aboutModel }
                                    , commands
                                    )
                           )
            in
                ( updateModel, Cmd.batch commands )


view : Model -> Html Message
view model =
    case model.route of
        Routing.HomeRoute ->
            Html.map Message (Home.view model.taco model.home)

        Routing.AboutRoute ->
            Html.map Message (About.view model.taco model.about)

        Routing.NotFoundRoute ->
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
    ( initialModel (parseLocation location), Cmd.none )


main : Program Never Model Message
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
