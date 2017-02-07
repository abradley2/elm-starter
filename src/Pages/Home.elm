module Pages.Home exposing (Model, HomeMsg(..), model, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Taco exposing (Taco, TacoMsg(..))


type HomeMsg
    = NoOp


type alias Model =
    { greeting : String
    }


model : Model
model =
    { greeting = "Hello World"
    }


update : Model -> HomeMsg -> ( Model, Cmd HomeMsg, TacoMsg )
update model msg =
    case msg of
        NoOp ->
            ( model, Cmd.none, Taco_NoOp )


view : Model -> Html HomeMsg
view model =
    h3 [] [ text "A simple view" ]
