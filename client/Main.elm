port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation exposing (Location)
import Routing exposing (Route, parseLocation)
import Taco exposing (Taco, TacoMsg, TacoMsg(..), taco)
import Home.Home as Home
import About.About as About


type alias Model =
    { route : Routing.Route
    , taco : Taco
    , home : Home.Model
    , about : About.Model
    }


initialModel : Route -> Model
initialModel route =
    { route = route
    , home = Home.model
    , about = About.model
    , taco = taco
    }


type Msg
    = OnLocationChange Location
    | HomeMsg Home.Msg
    | AboutMsg About.Msg


updateModel : Msg -> Model -> ( Model, Cmd Msg, TacoMsg )
updateModel msg model =
    case msg of
        OnLocationChange location ->
            let
                newLocation =
                    location
            in
                ( { model | route = parseLocation newLocation }, Cmd.none, Taco_NoOp )

        HomeMsg msg ->
            let
                ( home, cmd, tacoMsg ) =
                    Home.update model.home msg
            in
                ( { model | home = home }, Cmd.map HomeMsg cmd, tacoMsg )

        AboutMsg msg ->
            let
                ( about, cmd, tacoMsg ) =
                    About.update model.about msg
            in
                ( { model | about = about }, Cmd.map AboutMsg cmd, tacoMsg )


view : Model -> Html Msg
view model =
    case model.route of
        Routing.HomeRoute ->
            Html.map HomeMsg (Home.view model.taco model.home)

        Routing.AboutRoute ->
            Html.map AboutMsg (About.view model.taco model.about)

        Routing.NotFoundRoute ->
            notFound


notFound : Html Msg
notFound =
    div [ class "center measure" ]
        [ h3 [] [ text "Page Not Found :(" ]
        ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( newModel, cmds, tacoMsg ) =
            updateModel msg model
    in
        ( { newModel
            | taco = Taco.update tacoMsg newModel.taco
          }
        , Cmd.batch [ cmds, Cmd.none ]
        )


init : Location -> ( Model, Cmd Msg )
init location =
    ( initialModel (parseLocation location), Cmd.none )


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
