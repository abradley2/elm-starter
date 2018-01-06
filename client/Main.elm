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
import Update.RouteUpdate exposing (Route(..), parseLocation)
import View.ArmiesView exposing (armiesView)
import View.UnitsView exposing (unitsView)


port mount : (String -> message) -> Sub message


port unmount : (String -> message) -> Sub message


view : Model -> Html Message
view model =
    layout model
        (case model.route of
            ArmiesRoute ->
                Html.Styled.map Armies (armiesView model)

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
