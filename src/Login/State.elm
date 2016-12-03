module Login.State exposing (..)

import Types exposing (Model, Msg(..))
import Login.Types exposing (LoginModel, LoginMsg(..))


editUsername : LoginModel -> String -> LoginModel
editUsername loginModel username =
    { loginModel | username = username }


editPassword : LoginModel -> String -> LoginModel
editPassword loginModel password =
    { loginModel | password = password }


update : Msg -> ( Model, List (Cmd Msg) ) -> ( Model, List (Cmd Msg) )
update msg params =
    case msg of
        LoginMsg (EDIT_USERNAME username) ->
            let
                ( model, commands ) =
                    params
            in
                ( { model
                    | login = editUsername model.login username
                  }
                , commands
                )

        LoginMsg (EDIT_PASSWORD password) ->
            let
                ( model, commands ) =
                    params
            in
                ( { model
                    | login = editPassword model.login password
                  }
                , commands
                )

        _ ->
            params
