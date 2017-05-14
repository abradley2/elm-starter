module About.About exposing (Model, Msg(..), model, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Taco exposing (Taco, TacoMsg(..))


type Msg
    = NoOp


type alias Model =
    {}


type alias HomeModel homeModel =
    { homeModel
        | greeting : String
    }


type alias AppModel appModel homeModel =
    { appModel
        | about : Model
        , home : HomeModel homeModel
    }


model : Model
model =
    {}


update : Model -> Msg -> ( Model, Cmd Msg, TacoMsg )
update model msg =
    case msg of
        NoOp ->
            ( model, Cmd.none, Taco_NoOp )


view : Taco -> AppModel appModel homeModel -> Html Msg
view taco appModel =
    div [ class "center measure" ]
        [ h3 [] [ text "About Page" ]
        , h3 [] [ text appModel.home.greeting ]
        ]
