module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation exposing (Location)
import Pages.Home
import Pages.Navbar
import Pages.About
import Routing exposing (Route, parseLocation)
import Taco exposing (Taco, TacoMsg, TacoMsg(..), taco)


type alias Model =
    { taco : Taco
    , route : Routing.Route
    , home : Pages.Home.Model
    , about : Pages.About.Model
    , navbar : Pages.Navbar.Model
    }


initialModel : Route -> Model
initialModel route =
    { home = Pages.Home.model
    , about = Pages.About.model
    , navbar = Pages.Navbar.model
    , route = route
    , taco = taco
    }


type Msg
    = OnLocationChange Location
    | NavbarMsg Pages.Navbar.Msg
    | HomeMsg Pages.Home.Msg
    | AboutMsg Pages.About.Msg


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
                    Pages.Navbar.update model.navbar msg
            in
                ( { model | navbar = navbar }, Cmd.map NavbarMsg cmd, tacoMsg )

        HomeMsg msg ->
            let
                ( home, cmd, tacoMsg ) =
                    Pages.Home.update model.home msg
            in
                ( { model | home = home }, Cmd.map HomeMsg cmd, tacoMsg )

        AboutMsg msg ->
            let
                ( about, cmd, tacoMsg ) =
                    Pages.About.update model.about msg
            in
                ( { model | about = about }, Cmd.map AboutMsg cmd, tacoMsg )


view : Model -> Html Msg
view model =
    let
        activeView =
            case model.route of
                Routing.HomeRoute ->
                    Html.map HomeMsg (Pages.Home.view model.taco model)

                Routing.AboutRoute ->
                    Html.map AboutMsg (Pages.About.view model.taco model)

                Routing.NotFoundRoute ->
                    notFound
    in
        div []
            [ Html.map NavbarMsg (Pages.Navbar.view model.taco model)
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
