port module Main exposing (..)

import Css.Foreign exposing (p)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Layout exposing (layout)
import Message exposing (Message, Message(..))
import Model exposing (Model, model)
import Navigation exposing (Location)
import Update exposing (update)
import Update.RouteUpdate exposing (RouteModel(..), parseLocation)
import View.HomeView exposing (homeView)
import View.UnitsView exposing (unitsView)


port mount : (String -> message) -> Sub message


port unmount : (String -> message) -> Sub message


view : Model -> Html Message
view model =
    layout model
        (case model.routeModel of
            HomeRoute ->
                Html.Styled.map Home (homeView model)

            UnitsRoute ->
                Html.Styled.map Units (unitsView model)

            NotFoundRoute ->
                div [ class "center measure" ]
                    [ h3 [] [ text "Page Not Found :(" ]
                    ]
        )


subscriptions model =
    Sub.batch
        [ mount Mount
        , unmount Unmount
        ]


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
        , view = view >> toUnstyled
        , update = update
        , subscriptions = subscriptions
        }
