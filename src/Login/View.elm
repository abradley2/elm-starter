module Login.View exposing (loginView)

import Types exposing (Msg(..), Model)
import Login.Types exposing (LoginMsg(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


editPassword : String -> Msg
editPassword newPass =
    LoginMsg (EDIT_PASSWORD newPass)


editUsername : String -> Msg
editUsername newUser =
    LoginMsg (EDIT_USERNAME newUser)


loginView : Model -> Html Msg
loginView model =
    div
        [ class "container" ]
        [ h3 [] [ text "Hello World" ]
        , div
            [ class "form-group" ]
            [ label [] [ text "username" ]
            , input
                [ type' "text"
                , onInput editUsername
                , value model.login.username
                ]
                []
            ]
        , div
            [ class "form-group" ]
            [ label [] [ text "password" ]
            , input
                [ type' "password"
                , onInput editPassword
                , value model.login.password
                ]
                []
            ]
        ]
