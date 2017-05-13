module Pages.Navbar exposing (Model, Msg(..), model, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Taco exposing (Taco, TacoMsg, TacoMsg(..))


type alias Model =
    {}


type alias AppModel appModel =
    { appModel
        | navbar : Model
    }


type Msg
    = NoOp


navLink : String
navLink =
    "f6 link white dim mr3 mr4-ns"


model : Model
model =
    {}


update : Model -> Msg -> ( Model, Cmd Msg, TacoMsg )
update model msg =
    ( {}, Cmd.none, Taco_NoOp )


view : Taco -> AppModel appModel -> Html Msg
view taco model =
    nav [ class "flex justify-between bg-black-90" ]
        [ div [ class "pa3 flex items-center" ]
            [ a [ class navLink, href "#" ]
                [ text "Home" ]
            , a [ class navLink, href "#about" ]
                [ text "About" ]
            ]
        ]
