port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation exposing (Location)
import Routing exposing (Route, parseLocation)
import Message exposing (Message, Message(..))
import Model exposing (Model, model)
import Update.HomeUpdate exposing (homeUpdate)
import Update.AboutUpdate exposing (aboutUpdate)
import View.HomeView exposing (homeView)
import View.AboutView exposing (aboutView)


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
                ( updatedModel, Cmd.batch commands )


view : Model -> Html Message
view model =
    case model.route of
        Routing.HomeRoute ->
            Html.map Home (homeView model)

        Routing.AboutRoute ->
            Html.map About (aboutView model)

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
    ( model (parseLocation location), Cmd.none )


main : Program Never Model Message
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
