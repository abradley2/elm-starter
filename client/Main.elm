module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation exposing (Location)
import Routing exposing (Route, parseLocation)
import Taco exposing (Taco, TacoMsg, TacoMsg(..), taco)
import Home.Home as Home
import Navbar.Navbar as Navbar
import About.About as About


type alias Model =
    { taco : Taco
    , route : Routing.Route
    , home : Home.Model
    , about : About.Model
    , navbar : Navbar.Model
    }


initialModel : Route -> Model
initialModel route =
    { home = Home.model
    , about = About.model
    , navbar = Navbar.model
    , route = route
    , taco = taco
    }


type Msg
    = OnLocationChange Location
    | NavbarMsg Navbar.Msg
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

        NavbarMsg msg ->
            let
                ( navbar, cmd, tacoMsg ) =
                    Navbar.update model.navbar msg
            in
                ( { model | navbar = navbar }, Cmd.map NavbarMsg cmd, tacoMsg )

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
    let
        activeView =
            case model.route of
                Routing.HomeRoute ->
                    Html.map HomeMsg (Home.view model.taco model)

                Routing.AboutRoute ->
                    Html.map AboutMsg (About.view model.taco model)

                Routing.NotFoundRoute ->
                    notFound
    in
        div []
            [ Html.map NavbarMsg (Navbar.view model.taco model)
            , activeView
            ]


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
        ( { newModel | taco = Taco.update tacoMsg newModel.taco }, cmds )


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
