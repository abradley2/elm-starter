module Pages.Home exposing (HomeMsg, HomeModel, model, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Taco exposing (Taco, TacoMsg(..))


type HomeMsg
    = NoOp


type alias HomeModel =
    { greeting : String
    }


model : HomeModel
model =
    { greeting = "Hello World"
    }


update : HomeModel -> HomeMsg -> ( HomeModel, Cmd HomeMsg, TacoMsg )
update model msg =
    case msg of
        NoOp ->
            ( model, Cmd.none, Taco_NoOp )


view : Taco -> HomeModel -> Html HomeMsg
view taco model =
    h3 [] [ text "A simple view" ]
