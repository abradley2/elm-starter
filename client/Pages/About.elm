module Pages.About exposing (Model, Msg(..), model, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Taco exposing (Taco, TacoMsg(..))


type Msg
    = NoOp


type alias Model =
    {}


model : Model
model =
    {}


update : Model -> Msg -> ( Model, Cmd Msg, TacoMsg )
update model msg =
    case msg of
        NoOp ->
            ( model, Cmd.none, Taco_NoOp )


view : Taco -> Model -> Html Msg
view taco model =
    div [ class "center measure" ]
        [ h3 [] [ text "About Page" ]
        ]
