module Pages.Home exposing (Model, Msg(..), model, update, view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Taco exposing (Taco, TacoMsg, TacoMsg(..))


type alias Model =
    { greeting : String
    }


type alias AppModel appModel =
    { appModel
        | home : Model
    }


type Msg
    = NoOp
    | EditMsg String


model : Model
model =
    { greeting = "Hello World again"
    }


update : Model -> Msg -> ( Model, Cmd Msg, TacoMsg )
update model msg =
    case msg of
        EditMsg newMsg ->
            ( { model
                | greeting = newMsg
              }
            , Cmd.none
            , Taco_NoOp
            )

        NoOp ->
            ( model, Cmd.none, Taco_NoOp )


view : Taco -> AppModel appModel -> Html Msg
view taco appModel =
    div [ class "center measure" ]
        [ h3 [] [ text appModel.home.greeting ]
        , input
            [ type_ "text"
            , value appModel.home.greeting
            , onInput EditMsg
            ]
            []
        ]
