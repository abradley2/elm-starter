module Main exposing (..)

import Taco exposing (Taco, taco, TacoMsg(..))
import Html exposing (..)
import Navigation exposing (Location)
import Routing exposing (Route, parseLocation)
import Pages.Home


type alias Model =
    { taco : Taco
    , route : Routing.Route
    , home : Pages.Home.Model
    }


initialModel : Route -> Model
initialModel route =
    { home = Pages.Home.model
    , route = route
    , taco = taco
    }


type Msg
    = OnLocationChange Location
    | HomeMsg Pages.Home.Msg


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
                    Pages.Home.update model.home msg
            in
                ( { model | home = home }, Cmd.none, tacoMsg )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        ( newModel, cmds, tacoMsg ) =
            updateModel msg model
    in
        ( { newModel | taco = Taco.update tacoMsg newModel.taco }, cmds )


view : Model -> Html Msg
view model =
    Html.map HomeMsg (Pages.Home.view model.home)


init : Location -> ( Model, Cmd Msg )
init location =
    ( initialModel (parseLocation location), Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
