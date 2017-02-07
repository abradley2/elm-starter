module Pages.Home exposing (Model, Msg, model, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Taco exposing (Taco, TacoMsg(..))


type Msg
    = NoOp


type alias Model =
    { greeting : String
    }


model : Model
model =
    { greeting = "Hello World"
    }


update : Model -> Msg -> ( Model, Cmd Msg, TacoMsg )
update model msg =
    case msg of
        NoOp ->
            ( model, Cmd.none, Taco_NoOp )


view : Model -> Html Msg
view model =
    h3 [] [ text "A simple view" ]
