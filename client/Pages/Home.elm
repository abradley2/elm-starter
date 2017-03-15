module Pages.Home exposing (Model, Msg(..), model, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Taco exposing (Taco, TacoMsg(..))


type alias Model =
    { greeting : String
    }


type Msg
    = NoOp


model : Model
model =
    { greeting = "Hello World"
    }


update : Model -> Msg -> ( Model, Cmd Msg, TacoMsg )
update model msg =
    case msg of
        NoOp ->
            ( model, Cmd.none, Taco_NoOp )


view : Taco -> Model -> Html Msg
view taco model =
    h3 [] [ text "A simple elleven" ]
